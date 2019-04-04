//  Created by Akira Nakajima on 2018/09/04.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import Kibaan
@testable import KibaanSample

/// テスト用のモック画面
class MockViewController: MockBaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var containerView: UIView!

    // MARK: - Variables
    
    let subVc1 = MockSubViewController()
    let subVc2 = MockSubViewController()
    var tab: Tab = .tab1
    
    override var nextScreenTargetView: UIView {
        return containerView
    }
    
    override var foregroundSubControllers: [SmartViewController] {
        return tab == .tab1 ? [subVc1] : [subVc2]
    }
    
    // MARK: - Function
    
    func changeTab(tab: Tab) {
        leaveForegroundSubControllers()
        self.tab = tab
        enterForegroundSubControllers()
    }
    
    // MARK: - Enum
    
    enum Tab: String {
        case tab1
        case tab2
    }
}
