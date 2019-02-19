//  Created by Yamamoto Keita on 2018/07/11.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import Kibaan

class AppSetting: LocalSetting {
    
    static var shared = AppSetting()
    
    var footerTab: FooterTabViewController.Tab {
        get { return getEnum("footerTab", type: FooterTabViewController.Tab.self, defaultValue: FooterTabViewController.Tab.top) }
        set(value) { setEnum("footerTab", value: value) }
    }
}
