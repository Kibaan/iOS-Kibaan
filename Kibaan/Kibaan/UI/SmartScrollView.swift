//
//
//  Created by 山本敬太 on 2015/02/11.
//

import UIKit

open class SmartScrollView: UIScrollView, UIScrollViewDelegate {
    
    // MARK: - IBInspectable
    
    /// 上部スクロールインジケーター画像
    @IBInspectable open var topIndicatorImage: UIImage? {
        didSet {
            topIndicatorView = UIImageView(image: topIndicatorImage)
        }
    }
    
    /// 下部スクロールインジケーター画像
    @IBInspectable open var bottomIndicatorImage: UIImage? {
        didSet { bottomIndicatorView = UIImageView(image: bottomIndicatorImage) }
    }

    // MARK: - Variables
    
    open var topIndicatorView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = topIndicatorView {
                addSubview(view)
            }
        }
    }

    open var bottomIndicatorView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = bottomIndicatorView {
                addSubview(view)
            }
        }
    }

    /// インジケーターのサイズ
    open var indicatorSize: CGSize?
    
    /// 外部デリゲート
    private weak var outerDelegate: UIScrollViewDelegate?

    override open var delegate: UIScrollViewDelegate? {
        get {
            return outerDelegate
        }
        set(value) {
            outerDelegate = value
        }
    }
    
    /// プルトゥリフレッシュ実行時のアクション
    open var onPullToRefresh: (() -> Void)?
    
    // MARK: - Initializer
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    open func commonInit() {
        super.delegate = self
    }
    
    // MARK: - Life cycle
    
    // スクロールガイドなどをレイアウトする
    override open func layoutSubviews() {
        super.layoutSubviews()

        // 上スクロールガイド表示切り替え
        let scrollY = contentOffset.y
        let scrolled = (0 < scrollY)
        topIndicatorView?.isHidden = !scrolled
        
        // 下スクロールガイド表示切り替え
        let dispHeight = frame.size.height - scrollIndicatorInsets.bottom
        let moreScroll = scrollY < (contentSize.height - dispHeight)
        bottomIndicatorView?.isHidden = !moreScroll
        
        let fullH = frame.size.height
        
        let indicatorWidth = indicatorSize?.width ?? frame.size.width
        let indicatorX = (frame.size.width - indicatorWidth) / 2

        // インジケータの位置調整
        if let view = topIndicatorView {
            let height = indicatorSize?.height ?? view.frame.size.height
            view.frame = CGRect(x: indicatorX, y: scrollY, width: indicatorWidth, height: height)
        }
        if let view = bottomIndicatorView {
            let height = indicatorSize?.height ?? view.frame.size.height
            view.frame = CGRect(x: indicatorX, y: fullH - view.frame.size.height + scrollY, width: indicatorWidth, height: height)
        }
    }
    
    // MARK: - Support
    
    /// スクロール位置を初期化する
    ///
    /// - Parameter animated: アニメーションの有無
    open func resetScrollOffset(animated: Bool = false) {
        setContentOffset(CGPoint.zero, animated: animated)
    }
    
    // MARK: - Refresh Control
    
    open func addRefreshControl(attributedTitle: NSAttributedString? = nil, onPullToRefresh: (() -> Void)? = nil) {
        self.onPullToRefresh = onPullToRefresh
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = attributedTitle
        refreshControl?.addTarget(self, action: #selector(self.valueChanged), for: .valueChanged)
    }
    
    open func addRefreshControl(title: String = "引っ張って更新", onPullToRefresh: (() -> Void)? = nil) {
        addRefreshControl(attributedTitle: NSAttributedString(string: title), onPullToRefresh: onPullToRefresh)
    }
    
    open func endRefreshing() {
        refreshControl?.endRefreshing()
    }
    
    @objc private func valueChanged() {
        onPullToRefresh?()
    }
    
    // MARK: - UIScrollViewDelegate
    
    // forwardingTargetを使って動的にouterDelegateにメソッドを実行させたいが、
    // scrollViewDidScrollなど一部メソッドでforwardingTargetが呼ばれない問題があり断念
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        outerDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        outerDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        outerDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        outerDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        outerDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        outerDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }

    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        outerDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
