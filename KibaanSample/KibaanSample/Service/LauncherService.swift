//
//  Created by Yamamoto Keita on 2018/07/13.
//

import Foundation

/// 起動処理
class LauncherService {
    
    private var onComplete: (() -> Void)?
    
    func execute(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
        start()
    }
    
    /// 処理を開始する
    private func start() {
        completeProcess()
    }

    /// 完了処理
    private func completeProcess() {
        onComplete?()
    }
}
