//
//  Created by 山本 敬太 on 2014/12/19.
//

import UIKit

/// 上下のスクロールカーソルや影を追加できる UITableView
open class SmartTableView: UITableView {
    
    // MARK: - IBInspectable
    
    /// 上部スクロールインジケーター画像
    @IBInspectable open var topIndicatorImage: UIImage? {
        didSet { topIndicatorView = UIImageView(image: topIndicatorImage) }
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
    
    /// プルトゥリフレッシュ実行時のアクション
    open var onPullToRefresh: (() -> Void)?
    
    /// データなしラベル
    open var noDataLabel = SmartLabel()
    
    // MARK: - Initializer
    
    /// イニシャライザ
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /// イニシャライザ
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    open func commonInit() {
        self.addSubview(noDataLabel)
        noDataLabel.isBold = true
        noDataLabel.numberOfLines = 0
        noDataLabel.textColor = .white
        noDataLabel.backgroundColor = .clear
        noDataLabel.textAlignment = .center
        noDataLabel.isHidden = true
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        noDataLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        noDataLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        noDataLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.86).isActive = true
        noDataLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        
        // データがない部分の罫線を非表示にする為フッターをセットする
        // Groupedの場合はフッターをつけると最初のセクションのヘッダーに余分な余白が発生してしまうのでやらない
        if style != .grouped {
            tableFooterView = UIView()
        }
    }

    /// セルのクラスを指定する
    open func registerCellClass<T: UITableViewCell>(_ type: T.Type) {
        
        let xibName = cellClassName(of: T.self)

        // Cell の Xib を登録する
        register(UINib(nibName: xibName, bundle: nil), forCellReuseIdentifier: xibName)
    }

    /// 指定したインデックスに紐づくセルを取得する
    open func registeredCell<T: UITableViewCell>(_ indexPath: IndexPath, type: T.Type) -> T {
        let cellIdentifier = cellClassName(of: type)

        let cell = dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        // セル側で行番号を利用できるようtagに行番号を設定する（奇数・偶数で色分けする場合など）
        cell.tag = (indexPath as NSIndexPath).row
        return (cell as? T) ?? T()
    }
    
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
    
    /// データ無しラベルの表示 / 非表示を切り替える
    ///
    /// - Parameter show: 表示するかどうか
    open func showNoDataLabel(show: Bool) {
        noDataLabel.isHidden = !show
    }
    
    /// データ無しラベルに表示するテキストを設定する
    ///
    /// - Parameter noDataMessage: テキスト
    open func setNoDataMessage(noDataMessage: String?) {
        noDataLabel.text = noDataMessage
    }
    
    /// スクロール位置を初期化する
    ///
    /// - Parameter animated: アニメーションの有無
    open func resetScrollOffset(animated: Bool = false) {
        guard 0 < visibleCells.count else { return }
        if tableHeaderView != nil {
            setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
        } else {
            scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: animated)
        }
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
    
    /// セルクラス名を取得する
    private func cellClassName<T: UITableViewCell>(of cellClass: T.Type) -> String {
        let fullName = NSStringFromClass(cellClass)
        let className = fullName.split { $0 == "." }.map { String($0) }.last
        return className ?? fullName
    }
}
