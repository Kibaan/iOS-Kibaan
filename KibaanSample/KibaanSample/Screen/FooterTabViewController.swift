//  Created by Yamamoto Keita on 2018/06/29.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import Kibaan

class FooterTabViewController: BaseViewController {

    enum Tab: String {
        case top, chart, news, trade, menu
    }
    
    @IBOutlet weak var contentsView: UIView!
    
    @IBOutlet weak var topButton: SmartButton!
    @IBOutlet weak var chartButton: SmartButton!
    @IBOutlet weak var newsButton: SmartButton!
    @IBOutlet weak var tradeButton: SmartButton!
    @IBOutlet weak var menuButton: SmartButton!
    
    let tabButtons = ButtonGroup<Tab>()
    
    private var tabViewController: BaseViewController? {
        willSet {
            tabViewController?.leave()
            tabViewController?.view.removeFromSuperview()
            tabViewController?.removed()
        }
        didSet {
            if let controller = tabViewController {
                contentsView.addSubview(controller.view)
                AutoLayoutUtils.fit(controller.view, superView: contentsView)
            }
            
            if ScreenService.shared.foregroundController == self {
                tabViewController?.added()
                tabViewController?.enter()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabButtons.register(topButton, value: .top)
        tabButtons.register(chartButton, value: .chart)
        tabButtons.register(newsButton, value: .news)
        tabButtons.register(tradeButton, value: .trade)
        tabButtons.register(menuButton, value: .menu)
        tabButtons.selectedValue = AppSetting.shared.footerTab
        
        setTab(AppSetting.shared.footerTab)
    }
    
    override func onEnterForeground() {
        super.onEnterForeground()
        tabViewController?.enter()
    }
    
    override func onLeaveForeground() {
        super.onLeaveForeground()
        tabViewController?.leave()
    }
    
    @IBAction func actionFotterButton(_ sender: SmartButton) {
        tabButtons.select(button: sender)
        
        if let tab = tabButtons.selectedValue {
            setTab(tab)
        }
    }
    
    func setTab(_ tab: Tab) {
        AppSetting.shared.footerTab = tab
        // BaseViewController.Type型の変数にType情報を入れると、
        // Genericの型情報がBaseViewController.Typeになってしまうので、
        // switchで各ViewControllerのクラスをべた書きする。（改善したい）
        
        switch tab {
        case .top:
            setTabScreen(type: TopViewController.self)
        case .chart:
            setTabScreen(type: ChartViewController.self)
        case .news:
            setTabScreen(type: NewsViewController.self)
        case .trade:
            setTabScreen(type: TradeViewController.self)
        case .menu:
            setTabScreen(type: MenuViewController.self)
        }
    }
    
    @discardableResult
    func setTabScreen<T: BaseViewController>(type: T.Type) -> T {
        updateFooterButtonState(type: type)
        
        let controller = ViewControllerCache.get(type)
        tabViewController = controller
        return controller
    }
    
    private func updateFooterButtonState<T: BaseViewController>(type: T.Type) {
        switch type {
        case is TopViewController.Type: tabButtons.select(type: .top)
        case is ChartViewController.Type:       tabButtons.select(type: .chart)
        case is NewsViewController.Type:        tabButtons.select(type: .news)
        case is TradeViewController.Type:       tabButtons.select(type: .trade)
        case is MenuViewController.Type:        tabButtons.select(type: .menu)
        default: break
        }
    }
}
