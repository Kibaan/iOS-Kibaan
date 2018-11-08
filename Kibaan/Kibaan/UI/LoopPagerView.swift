//
//  Created by 山本敬太 on 2015/01/31.
//

import UIKit

/// ページングが左右端でループするスクロールビュー
open class LoopPagerView: BaseScrollView {

    /// ページ変更時の処理
    open var pageChangeAction: ((Int) -> Void)?

    private var pageArray: [UIView] = []
    
    private var _pageIndex: Int = 0
    
    /// ページインデックス
    open var pageIndex: Int {
        get { return _pageIndex }
        set(index) {
            changePage(index, animated: false)
        }
    }
    
    /// ページ変更時のイベントを実行するか
    /// changePageでプログラムからページ変更した場合はページ変更イベントが即座に実行されるので、
    /// スクロールイベントで実行されないようこのフラグで制御する
    private var enablePageChangeAction = true
    
    /// スクロール時のイベント実行するか
    /// サイズ変更時にscrollViewDidScrollが呼ばれるが、その際スクロール時のイベントが実行されないようこのフラグで制御している
    private var enableScrollAction = true

    /// 直前のサイズ
    /// サイズが変わった場合にページサイズや位置の調整が必要なため、
    /// サイズ変更が分かるよう直前のサイズを保存している
    private var previousSize: CGSize?
    
    // 初期設定
    override open func commonInit() {
        super.commonInit()
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        bounces = true
    }
    
    // レイアウトする
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // サイズが変わった場合
        if previousSize == nil || previousSize != frame.size {
            enableScrollAction = false
            updateScrollSize()
            resizePageView()
            updatePagePosition()
            let scrollOffset = CGFloat(pageIndex) * frame.size.width
            setContentOffset(CGPoint(x: scrollOffset, y: 0), animated: false)
            enableScrollAction = true
            
            previousSize = frame.size
        }
    }

    override open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if enableScrollAction {
            scrollAction()
        }
    }
    
    override open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        super.scrollViewDidEndScrollingAnimation(scrollView)
        enablePageChangeAction = true
    }
    
    /// ページを追加する
    open func addPageView(_ view: UIView) {
        pageArray += [view]
        
        updatePagePosition()
        updateScrollSize()
        
        addSubview(view)
    }
    
    /// 表示するページインデックスを変更する
    open func changePage(_ pageIndex: Int, animated: Bool = false) {
        _pageIndex = pageIndex
        
        pageChangeAction?(pageIndex)
        
        // pageChangeAction 実行済みなので、アニメーションでページ切り替えする場合はスクロールイベントで再度呼ばれないようにする
        // (スクロールイベントからのみ pageChangeAction を呼ぶ作りだと、スクロールで経由したページ全てに対して呼ばれてしまうためまずい)
        
        let scrollOffset = CGFloat(pageIndex) * frame.size.width
        if animated && scrollOffset != contentOffset.x {
            enablePageChangeAction = false
        }
        
        setContentOffset(CGPoint(x: scrollOffset, y: 0), animated: animated)
    }
    
    // スクロール時の処理
    private func scrollAction() {
        let fullWidth = frame.size.width * CGFloat(pageArray.count)
        if contentOffset.x < 0 {
            // 左端を超える場合は右端に移動する
            contentOffset.x = fullWidth + contentOffset.x
        } else if fullWidth <= contentOffset.x {
            // 右端を超える場合は2ページ目に移動する
            contentOffset.x -= fullWidth
        }
        
        updatePagePosition()
        
        // ページインデックス更新
        var nextIndex = Int((contentOffset.x / frame.size.width) + 0.5) // 半分以上見えたら次ページに切り替えるので0.5足す
        if pageArray.count - 1 < nextIndex {
            nextIndex = 0
        }
        
        if enablePageChangeAction {
            if _pageIndex != nextIndex {
                _pageIndex = nextIndex
                pageChangeAction?(pageIndex)
            }
        }
    }
    
    // 各ページのX座標を調整する
    private func updatePagePosition() {
        // まずはページ順に横並び
        pageArray.enumerated().forEach {
            $0.element.frame.origin.x = frame.size.width * CGFloat($0.offset)
        }
        
        // 右端ページのさらに右が見える場合、1ページ目をさらに右にもってくる
        if frame.size.width * CGFloat(pageArray.count - 1) < contentOffset.x {
            pageArray.first?.frame.origin.x = frame.size.width * CGFloat(pageArray.count)
        }
    }
    
    // スクロールコンテンツのサイズを設定する
    private func updateScrollSize() {
        // ページ数 + 余白1ページ分のサイズをとる
        let width = frame.size.width * CGFloat(pageArray.count + 1)
        contentSize.width = width
    }
    
    // ページViewをフレームのサイズに合わせる
    private func resizePageView() {
        for view in pageArray {
            view.frame.size = frame.size
        }
    }

}
