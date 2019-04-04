//  Created by Akira Nakajima on 2018/09/04.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import Kibaan
@testable import KibaanSample

class MockBaseViewController: SmartViewController {

    // MARK: - Variables
    
    var startCount = 0
    var stopCount = 0
    
    // MARK: - Life cycle
    
    override func onEnterForeground() {
        startCount += 1
        super.onEnterForeground()
    }
    
    override func onLeaveForeground() {
        stopCount += 1
        super.onLeaveForeground()
    }
}
