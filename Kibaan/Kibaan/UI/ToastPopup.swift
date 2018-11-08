import UIKit

/// 画面上部からスライド表示するトースト
open class ToastPopup: SmartLabel {
    
    // MARK: - Constants
    
    static public var padding: CGFloat = 2.5
    static public var cornerRadius: CGFloat = 5.0
    static public var textSize: CGFloat = 15.0
    static public var animationDuration: TimeInterval = 0.3
    static public var defaultBackgroundColor = UIColor(rgbValue: 0xFFFFFF, alpha: 0.95)
    static public var defaultTextColor = UIColor.black
    
    // MARK: - Variables

    private static var displayingList: [ToastPopup] = []
    private var timer: Timer?
    private var topConstraint: NSLayoutConstraint?
    private var displayTime: TimeInterval = 3.0
    private var topY: CGFloat {
        let statusBarHeightWithMargin = UIApplication.shared.statusBarFrame.height + 10
        if #available(iOS 11.0, *) {
            return max(superview?.safeAreaInsets.top ?? 0, statusBarHeightWithMargin)
        } else {
            return statusBarHeightWithMargin
        }
    }
    
    // MARK: - Show
    
    static public func show(_ message: String,
                            backgroundColor: UIColor = defaultBackgroundColor,
                            textColor: UIColor = defaultTextColor,
                            displayTime: TimeInterval = 3.0) {
        hideAllToastPopup()
        let toast = create(message, backgroundColor: backgroundColor, textColor: textColor, displayTime: displayTime)
        displayingList.append(toast)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(toast)
            toast.adjustLayout(window)
        }
        // viewWillAppearなどで呼び出すと表示されない問題を解消する為、表示するまでにディレイを設けた
        toast.perform(#selector(toast.start), with: nil, afterDelay: 0.0)
    }

    @objc private func start() {
        UIApplication.shared.keyWindow?.bringSubviewToFront(self)
        slideIn(-frame.height)
        scheduledTimer(displayTime)
    }
    
    // MARK: - Creator
    
    private static func create(_ message: String, backgroundColor: UIColor, textColor: UIColor, displayTime: TimeInterval) -> ToastPopup {
        let width = UIScreen.main.bounds.width * 0.96
        let toast = ToastPopup()
        toast.backgroundColor = backgroundColor
        toast.textColor = textColor
        toast.isUserInteractionEnabled = true
        toast.layer.cornerRadius = cornerRadius
        toast.clipsToBounds = true
        toast.numberOfLines = 0
        toast.text = message
        toast.displayTime = displayTime
        toast.font = UIFont.systemFont(ofSize: ToastPopup.textSize)
        toast.padding = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        let rect = toast.sizeThatFits(CGSize(width: width - padding * 2, height: CGFloat.greatestFiniteMagnitude))
        toast.frame.size.height = rect.height + padding * 2
        toast.frame.origin.y = -toast.frame.height
        return toast
    }
    
    // MARK: - Animation
    
    private func slideIn(_ preY: CGFloat) {
        superview?.layoutIfNeeded()
        topConstraint?.constant = topY
        UIView.animate(withDuration: ToastPopup.animationDuration, delay: 0, options: .curveLinear, animations: { [unowned self] in
            self.superview?.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func slideOut() {
        superview?.layoutIfNeeded()
        topConstraint?.constant = -self.frame.height
        UIView.animate(withDuration: ToastPopup.animationDuration, animations: { [unowned self] in
            self.superview?.layoutIfNeeded()
        }, completion: { [unowned self] result in
            self.removeFromSuperview()
            ToastPopup.displayingList.remove(element: self)
        })
        stopTimer()
    }
    
    // MARK: - Timer
    
    private func scheduledTimer(_ displayTime: TimeInterval) {
        self.displayTime = displayTime
        timer = Timer.scheduledTimer(timeInterval: displayTime, target: self, selector: #selector(slideOut), userInfo: nil, repeats: false)
    }
    
    private func stopTimer() {
        if let timer = timer {
            timer.invalidate()
        }
        timer = nil
    }
    
    // MARK: - Touch Event
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        stopTimer()
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchEvent = touches.first {
            let newDy = touchEvent.location(in: self).y
            let prevDy = touchEvent.previousLocation(in: self).y
            let move = newDy - prevDy
            frame.origin.y = min(topY, frame.origin.y + move)
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if frame.origin.y - UIApplication.shared.statusBarFrame.height < frame.height * -0.2 {
            slideOut()
        } else {
            slideIn(frame.origin.y)
            scheduledTimer(displayTime)
        }
    }
    
    // MARK: - Other
    
    private func adjustLayout(_ window: UIWindow) {
        let width = UIScreen.main.bounds.width * 0.96
        topConstraint = topAnchor.constraint(equalTo: window.topAnchor, constant: -self.frame.height)
        topConstraint?.isActive = true
        heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
        centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private static func hideAllToastPopup() {
        displayingList.forEach {
            $0.forceHide()
        }
        displayingList.removeAll()
    }
    
    private func forceHide() {
        stopTimer()
        self.removeFromSuperview()
    }
}
