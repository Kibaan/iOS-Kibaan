import UIKit

open class ToolTip: CustomView {
    
    // MARK: - Enums
    
    public enum Alignment {
        case none
        case left
        case right
    }
    
    // MARK: - Constants
    
    private let arrowHeight: CGFloat = 14
    private let arrowWidth: CGFloat = 8
    private let arrowMargin: CGFloat = 4
    private let miniumOuterMargin: CGFloat = 4
    private let margin: CGFloat = 10
    private let defaultPadding: CGFloat = 10
    
    // MARK: - Variables
    
    private var text: String = ""
    private var point: CGPoint? = nil
    private var width: CGFloat? = nil
    private var alignment: Alignment = .none
    open var padding: UIEdgeInsets {
        get { return messageLabel.padding }
        set(value) { messageLabel.padding = value }
    }
    open var textSize: CGFloat = UIFont.labelFontSize {
        didSet {
            messageLabel.font = messageLabel.font.withSize(textSize)
            adjustContent()
        }
    }
    private var targetView: UIView? = nil {
        didSet {
            if let view = targetView {
                let tmpPoint = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
                var point = view.convert(tmpPoint, to: nil)
                point.y += (view.frame.height / 2)
                self.point = point
            }
        }
    }
    open var onComplete: (() -> Void)?
    
    // MARK: - Outlets
    
    open var messageLabel: SmartLabel!
    open var heightConstraint: NSLayoutConstraint!
    open var topConstraint: NSLayoutConstraint!
    open var leftConstraint: NSLayoutConstraint!
    open var rightConstraint: NSLayoutConstraint!
    
    // MARK: - Initializer
    
    override open func commonInit() {
        super.commonInit()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        messageLabel = makeMessageLabel()
        addSubview(messageLabel)
        generateDefaultConstraint()
    }
    
    private func makeMessageLabel() -> SmartLabel {
        let label = SmartLabel()
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.padding = UIEdgeInsets(top: defaultPadding, left: defaultPadding, bottom: defaultPadding, right: defaultPadding)
        label.isUserInteractionEnabled = true
        label.font = label.font.withSize(textSize)
        label.textColor = UIColor(rgbValue: 0x333333)
        label.cornerRadius = 10
        return label
    }
    
    private func generateDefaultConstraint() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = AutoLayoutUtils.fixedConstraint(messageLabel, attribute: .height, value: 10)
        leftConstraint = messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 100)
        rightConstraint = messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -100)
        topConstraint = messageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        topConstraint.isActive = true
        addConstraints([heightConstraint])
    }
    
    // MARK: - Builder
    
    open func text(_ text: String?) -> ToolTip {
        self.text = text ?? ""
        return self
    }
    
    open func textSize(_ textSize: CGFloat) -> ToolTip {
        self.textSize = textSize
        return self
    }
    
    open func point(_ point: CGPoint) -> ToolTip {
        self.point = point
        return self
    }
    
    open func targetView(_ targetView: UIView?) -> ToolTip {
        self.targetView = targetView
        return self
    }
    
    open func width(_ width: CGFloat, alignment: Alignment) -> ToolTip {
        messageLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.alignment = alignment
        return self
    }
    
    // MARK: - Show
    
    open func show() {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.view.addSubview(self)
        }
    }
    
    // MARK: - Actions
    
    private func complete() {
        removeFromSuperview()
        onComplete?()
    }
    
    // MARK: - Life cycle
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        adjustContent()
    }
    
    // MARK: - Layout
    
    private func adjustContent() {
        guard let point = point, let parentView = superview else { return }
        AutoLayoutUtils.fit(self, superView: parentView)
        
        // setting text
        messageLabel.text = text
        
        // adjust constraint
        adjustHeightConstraint(point)
        adjustTopConstraint(point)
        
        // add arrow layer
        addArrowLayer(point)
        
        updateConstraintsIfNeeded()
    }
    
    private func addArrowLayer(_ point: CGPoint) {
        // delete before layer
        self.layer.sublayers?.filter { $0 as? CAShapeLayer != nil }.forEach {
            $0.removeFromSuperlayer()
        }
        let isTop = isTopArrow(point: point, labelHeight: heightConstraint.constant)
        let height = isTop ? arrowHeight + arrowMargin :  (arrowHeight + arrowMargin) * -1
        let line = UIBezierPath()
        line.move(to: point)
        line.addLine(to: CGPoint(x: point.x - arrowWidth, y: point.y + height))
        line.addLine(to: CGPoint(x: point.x + arrowWidth, y: point.y + height))
        line.close()
        let arrowLayer = CAShapeLayer()
        arrowLayer.fillColor = UIColor.white.cgColor
        arrowLayer.path = line.cgPath
        layer.addSublayer(arrowLayer)
    }
    
    private func adjustHeightConstraint(_ point: CGPoint) {
        heightConstraint.constant = 0
        adjustSideConstraint(point, containsPadding: true)
        let width = messageLabel.frame.width - padding.left - padding.right
        let height = messageLabel.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
        heightConstraint.constant = height + padding.top + padding.bottom
    }
    
    private func adjustTopConstraint(_ point: CGPoint) {
        if isTopArrow(point: point, labelHeight: heightConstraint.constant) {
            topConstraint.constant = point.y + arrowHeight
        } else {
            topConstraint.constant = (point.y - heightConstraint.constant - arrowHeight)
        }
    }
    
    private func adjustSideConstraint(_ point: CGPoint, containsPadding: Bool = false) {
        let baseConstant: CGFloat = containsPadding ? miniumOuterMargin + padding.left + padding.right : miniumOuterMargin
        let compressedWidth = messageLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
        let contentViewWidth = messageLabel.frame.width + leftConstraint.constant + rightConstraint.constant
        var leftConstant = baseConstant
        var rightConstant = baseConstant
        if isLeft(point) {
            leftConstant = point.x - (arrowWidth + margin)
            if compressedWidth + (padding.left + padding.right) < contentViewWidth - leftConstant {
                rightConstant = contentViewWidth - (leftConstant + compressedWidth) - (padding.left + padding.right)
            } else {
                rightConstant = baseConstant
            }
        } else {
            rightConstant = contentViewWidth - (point.x + (arrowWidth + margin))
            if compressedWidth + (padding.left + padding.right) < contentViewWidth - rightConstant {
                leftConstant = contentViewWidth - (leftConstant + compressedWidth) - (padding.left + padding.right)
            } else {
                leftConstant = baseConstant
            }
        }
        if alignment == .left {
            leftConstraint.constant = miniumOuterMargin
        } else if alignment == .right {
            rightConstraint.constant = -miniumOuterMargin
        } else {
            leftConstraint.constant = max(miniumOuterMargin, leftConstant)
            rightConstraint.constant = max(0, rightConstant)
        }
        leftConstraint.isActive = alignment != .right
        rightConstraint.isActive = alignment != .left
    }
    
    // MARK: - Judge
    
    private func isLeft(_ point: CGPoint) -> Bool {
        return (self.frame.size.width / 2) >= point.x
    }
    
    private func isTopArrow(point: CGPoint, labelHeight: CGFloat) -> Bool {
        let limit = self.frame.size.height
        return limit - miniumOuterMargin >= point.y + labelHeight + arrowHeight
    }
    
    // MARK: - Action
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        complete()
        return nil
    }
}
