//  Created by Akira Nakajima on 2018/09/04.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import XCTest
import Kibaan
@testable import KibaanSample

class ScreenTransitionTests: XCTestCase {
    
    override func setUp() {
    }
    
    func testViewControllerInit() {
        ViewControllerCache.shared.clear()
        let vc = MockViewController()
        XCTAssertEqual(0, vc.startCount)
        XCTAssertEqual(0, vc.stopCount)
    }

    func testSetRoot() {
        ViewControllerCache.shared.clear()
        let vc1 = ScreenService.shared.setRoot(MockViewController.self)

        // 1.rootViewControllerのonStartが呼ばれ、isForegroundがtrueであること
        XCTAssertEqual(1, vc1.startCount)
        XCTAssertTrue(vc1.isForeground)

        // 2.foregroundSubControllersのonStartも呼ばれ、isForegroundがtrueであること
        XCTAssertEqual(1, vc1.subVc1.startCount)
        XCTAssertTrue(vc1.subVc1.isForeground)
        XCTAssertEqual(0, vc1.subVc2.startCount)
        XCTAssertFalse(vc1.subVc2.isForeground)

        _ = ScreenService.shared.setRoot(MockSubViewController.self)

        // 3.rootViewControllerのonStopが呼ばれ、isForegroundがfalseであること
        XCTAssertEqual(1, vc1.stopCount)
        XCTAssertFalse(vc1.isForeground)

        // 4.foregroundSubControllersのonStopも呼ばれ、isForegroundがfalseであること
        XCTAssertEqual(1, vc1.subVc1.stopCount)
        XCTAssertFalse(vc1.subVc1.isForeground)
        XCTAssertEqual(0, vc1.subVc2.stopCount)
        XCTAssertFalse(vc1.subVc2.isForeground)
    }

    func testAddSubscreen() {
        ViewControllerCache.shared.clear()
        let vc1 = ScreenService.shared.setRoot(MockViewController.self)
        let addVc = ScreenService.shared.addSubScreen(MockViewController.self, id: "2")!

        // 1.Addしたスクリーンの確認
        XCTAssertEqual(1, addVc.startCount)
        XCTAssertTrue(addVc.isForeground)
        XCTAssertEqual(1, addVc.subVc1.startCount)
        XCTAssertTrue(addVc.subVc1.isForeground)
        XCTAssertEqual(0, addVc.subVc2.startCount)
        XCTAssertFalse(addVc.subVc2.isForeground)

        // 2.Rootスクリーンの確認
        XCTAssertEqual(1, vc1.stopCount)
        XCTAssertFalse(vc1.isForeground)
        XCTAssertEqual(1, vc1.subVc1.stopCount)
        XCTAssertFalse(vc1.subVc1.isForeground)
        XCTAssertEqual(0, vc1.subVc2.stopCount)
        XCTAssertFalse(vc1.subVc2.isForeground)

        ScreenService.shared.removeSubScreen()

        // 3.Removeしたスクリーンの確認
        XCTAssertEqual(1, addVc.stopCount)
        XCTAssertFalse(addVc.isForeground)
        XCTAssertEqual(1, addVc.subVc1.stopCount)
        XCTAssertFalse(addVc.subVc1.isForeground)
        XCTAssertEqual(0, addVc.subVc2.stopCount)
        XCTAssertFalse(addVc.subVc2.isForeground)

        // 4.Rootスクリーンの確認
        XCTAssertEqual(2, vc1.startCount)
        XCTAssertTrue(vc1.isForeground)
        XCTAssertEqual(2, vc1.subVc1.startCount)
        XCTAssertTrue(vc1.subVc1.isForeground)
        XCTAssertEqual(0, vc1.subVc2.stopCount)
        XCTAssertFalse(vc1.subVc2.isForeground)
    }

    func testAddOverlay() {
        ViewControllerCache.shared.clear()
        let vc1 = ScreenService.shared.setRoot(MockViewController.self)
        let addVc = vc1.addOverlay(MockSubViewController.self)!

        // 1.Addしたスクリーンの確認
        XCTAssertEqual(1, addVc.startCount)
        XCTAssertTrue(addVc.isForeground)

        // 2.Rootスクリーンの確認
        XCTAssertEqual(0, vc1.stopCount)
        XCTAssertTrue(vc1.isForeground)
        XCTAssertEqual(0, vc1.subVc1.stopCount)
        XCTAssertTrue(vc1.subVc1.isForeground)
        XCTAssertEqual(0, vc1.subVc2.stopCount)
        XCTAssertFalse(vc1.subVc2.isForeground)

        vc1.removeOverlay()

        // 3.Removeしたスクリーンの確認
        XCTAssertEqual(1, addVc.stopCount)
        XCTAssertFalse(addVc.isForeground)

        // 4.Rootスクリーンの確認
        XCTAssertEqual(1, vc1.startCount)
        XCTAssertTrue(vc1.isForeground)
        XCTAssertEqual(1, vc1.subVc1.startCount)
        XCTAssertTrue(vc1.subVc1.isForeground)
        XCTAssertEqual(0, vc1.subVc2.stopCount)
        XCTAssertFalse(vc1.subVc2.isForeground)
    }

    func testAddNextScreen() {
        ViewControllerCache.shared.clear()
        let vc1 = ScreenService.shared.setRoot(MockViewController.self)
        let addVc = vc1.addNextScreen(MockSubViewController.self)!

        // 1.Addしたスクリーンの確認
        XCTAssertEqual(1, addVc.startCount)
        XCTAssertTrue(addVc.isForeground)

        // 2.Rootスクリーンの確認
        XCTAssertEqual(1, vc1.startCount)
        XCTAssertFalse(vc1.isForeground)
        XCTAssertEqual(1, vc1.subVc1.stopCount)
        XCTAssertFalse(vc1.subVc1.isForeground)
        XCTAssertEqual(0, vc1.subVc2.stopCount)
        XCTAssertFalse(vc1.subVc2.isForeground)

        vc1.removeNextScreen()

        // 3.Removeしたスクリーンの確認
        XCTAssertEqual(1, addVc.stopCount)
        XCTAssertFalse(addVc.isForeground)

        // 4.Rootスクリーンの確認
        XCTAssertEqual(2, vc1.startCount)
        XCTAssertTrue(vc1.isForeground)
        XCTAssertEqual(2, vc1.subVc1.startCount)
        XCTAssertTrue(vc1.subVc1.isForeground)
        XCTAssertEqual(0, vc1.subVc2.stopCount)
        XCTAssertFalse(vc1.subVc2.isForeground)
    }

    func testFooterTab() {
        ViewControllerCache.shared.clear()
        let footerTabVc = ScreenService.shared.setRoot(FooterTabViewController.self)
        let vc1 = footerTabVc.setTabScreen(type: MockViewController.self)

        // 1.Setしたスクリーンの確認
        XCTAssertEqual(1, vc1.startCount)
        XCTAssertTrue(vc1.isForeground)
        XCTAssertEqual(1, vc1.subVc1.startCount)
        XCTAssertTrue(vc1.subVc1.isForeground)
        XCTAssertEqual(0, vc1.subVc2.stopCount)
        XCTAssertFalse(vc1.subVc2.isForeground)

        let vc2 = footerTabVc.setTabScreen(type: MockSubViewController.self)

        // 2.Setしたスクリーンの確認
        XCTAssertEqual(1, vc2.startCount)
        XCTAssertTrue(vc2.isForeground)

        // 3.1つ前のスクリーン確認
        XCTAssertEqual(1, vc1.stopCount)
        XCTAssertFalse(vc1.isForeground)
        XCTAssertEqual(1, vc1.subVc1.stopCount)
        XCTAssertFalse(vc1.subVc1.isForeground)
        XCTAssertEqual(0, vc1.subVc2.stopCount)
        XCTAssertFalse(vc1.subVc2.isForeground)
    }

    func testTabChange() {
        ViewControllerCache.shared.clear()
        let vc = ScreenService.shared.setRoot(MockViewController.self)

        // 1.初期表示状態の確認
        XCTAssertEqual(1, vc.subVc1.startCount)
        XCTAssertTrue(vc.subVc1.isForeground)
        XCTAssertEqual(0, vc.subVc2.startCount)
        XCTAssertFalse(vc.subVc2.isForeground)

        // タブの切り替え
        vc.changeTab(tab: .tab2)

        // 2.タブ切り替え後の確認
        XCTAssertEqual(1, vc.subVc1.startCount)
        XCTAssertEqual(1, vc.subVc1.stopCount)
        XCTAssertFalse(vc.subVc1.isForeground)
        XCTAssertEqual(1, vc.subVc2.startCount)
        XCTAssertEqual(0, vc.subVc2.stopCount)
        XCTAssertTrue(vc.subVc2.isForeground)
    }

    func testScenario() {
        ViewControllerCache.shared.clear()
        let footerTabVc = ScreenService.shared.setRoot(FooterTabViewController.self)
        let vc1 = footerTabVc.setTabScreen(type: MockSubViewController.self)

        // 1.Setしたスクリーンの確認
        XCTAssertEqual(1, vc1.startCount)
        XCTAssertTrue(vc1.isForeground)

        // フッターを切り替える
        let vc2 = footerTabVc.setTabScreen(type: MockViewController.self)

        // 2.Setしたスクリーンの確認
        XCTAssertEqual(1, vc2.startCount)
        XCTAssertTrue(vc2.isForeground)
        XCTAssertEqual(1, vc2.subVc1.startCount)
        XCTAssertTrue(vc2.subVc1.isForeground)
        XCTAssertEqual(0, vc2.subVc2.stopCount)
        XCTAssertFalse(vc2.subVc2.isForeground)

        // 3.1つ前のスクリーン確認
        XCTAssertEqual(1, vc1.stopCount)
        XCTAssertFalse(vc1.isForeground)

        // 次の画面を表示する
        let nextVc = vc2.addNextScreen(MockSubViewController.self, id: "2")!

        // 4.Addしたスクリーンの確認
        XCTAssertEqual(1, nextVc.startCount)
        XCTAssertTrue(nextVc.isForeground)

        // 5.Footerのスクリーン確認
        XCTAssertEqual(1, vc2.stopCount)
        XCTAssertFalse(vc2.isForeground)
        XCTAssertEqual(1, vc2.subVc1.stopCount)
        XCTAssertFalse(vc2.subVc1.isForeground)
        XCTAssertEqual(0, vc2.subVc2.stopCount)
        XCTAssertFalse(vc2.subVc2.isForeground)

        // 前の画面に戻る
        nextVc.owner?.removeNextScreen()

        // 6.閉じたスクリーンの確認
        XCTAssertEqual(1, nextVc.stopCount)
        XCTAssertFalse(nextVc.isForeground)

        // 7.Footerのスクリーン確認
        XCTAssertEqual(2, vc2.startCount)
        XCTAssertTrue(vc2.isForeground)
        XCTAssertEqual(2, vc2.subVc1.startCount)
        XCTAssertTrue(vc2.subVc1.isForeground)
        XCTAssertEqual(0, vc2.subVc2.startCount)
        XCTAssertFalse(vc2.subVc2.isForeground)

        // オーバーレイ表示する
        let overlayVc = vc2.addOverlay(MockSubViewController.self, id: "3")!

        // 8.Addしたスクリーンの確認
        XCTAssertEqual(1, overlayVc.startCount)
        XCTAssertTrue(overlayVc.isForeground)

        // 9.Footerのスクリーン確認
        XCTAssertEqual(1, vc2.stopCount)
        XCTAssertTrue(vc2.isForeground)
        XCTAssertEqual(1, vc2.subVc1.stopCount)
        XCTAssertTrue(vc2.subVc1.isForeground)
        XCTAssertEqual(0, vc2.subVc2.stopCount)
        XCTAssertFalse(vc2.subVc2.isForeground)

        // オーバーレイを閉じる
        overlayVc.owner?.removeOverlay()

        // 10.閉じたスクリーンの確認
        XCTAssertEqual(1, overlayVc.stopCount)
        XCTAssertFalse(overlayVc.isForeground)

        // 11.Footerのスクリーン確認
        XCTAssertEqual(1, vc2.stopCount)
        XCTAssertTrue(vc2.isForeground)
        XCTAssertEqual(1, vc2.subVc1.stopCount)
        XCTAssertTrue(vc2.subVc1.isForeground)
        XCTAssertEqual(0, vc2.subVc2.stopCount)
        XCTAssertFalse(vc2.subVc2.isForeground)
    }
}
