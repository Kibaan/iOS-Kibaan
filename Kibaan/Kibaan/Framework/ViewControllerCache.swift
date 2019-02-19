import UIKit

/// ViewControllerのキャッシュ
public class ViewControllerCache {
    
    static public var shared = ViewControllerCache()

    private var controllerMap: [String: UIViewController] = [:]
    
    /// 指定したクラスのViewController を取得する
    /// キャッシュがある場合はキャッシュを利用し、ない場合は新たにViewControllerを作成する
    public func get<T: UIViewController>(_ type: T.Type, nibName: String? = nil, id: String? = nil, cache: Bool = true) -> T {

        let fullName = NSStringFromClass(type)

        var controllerKey = fullName
        if let id = id {
            controllerKey.append("." + id)
        }
        var controller: UIViewController? = cache ? controllerMap[controllerKey] : nil
        if controller == nil {
            controller = create(type, nibName: nibName, id: id)
            if cache {
                controllerMap[controllerKey] = controller
            }
        }
        if let controller = controller as? T {
            return controller
        }
        fatalError("unexpected error")
    }
    
    /// 指定したクラスのViewControllerを作成する
    public func create<T: UIViewController>(_ type: T.Type, nibName: String? = nil, id: String? = nil) -> T {
        let fullName = NSStringFromClass(type)
        let className = fullName.components(separatedBy: ".").last
        let controller = T(nibName: nibName ?? className, bundle: nil)
        if let baseViewController = controller as? BaseViewController, let id = id {
            baseViewController.viewID = id
        }
        return controller
    }
    
    /// 指定したクラスのキャッシュされたViewControllerを取得する
    public func getCache<T: UIViewController>(_ type: T.Type, id: String? = nil) -> T? {
        
        let fullName = NSStringFromClass(type)
        var controllerKey = fullName
        if let id = id {
            controllerKey.append("." + id)
        }
        
        return controllerMap[controllerKey] as? T
    }
    
    /// キャッシュをクリアする
    public func clear() {
        controllerMap.removeAll()
    }
}
