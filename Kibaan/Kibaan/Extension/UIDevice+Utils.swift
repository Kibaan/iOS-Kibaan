import UIKit

public extension UIDevice {
    
    /// 端末のモデル名を取得する
    ///
    /// <モデル名の例>
    /// - "iPhone10,4" (iPhone 8)
    /// - "iPhone10,2" (iPhone 8 Plus)
    /// - "iPad5,3" (iPad Air 2 WiFi)
    var detailedModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
