import Kibaan

/// 起動画面
class LauncherViewController: BaseViewController {

    let launcherService = LauncherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        launcherService.execute {[unowned self] in
            self.showFirstPage()
        }
    }
    
    private func showFirstPage() {
        ScreenService.shared.setRoot(FooterTabViewController.self)
    }
}
