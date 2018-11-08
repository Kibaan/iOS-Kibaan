import UIKit

public extension UILayoutPriority {
    // required     = 1000 (必須。動的に変更不可)
    // defaultHigh  = 750  (高め)
    // defaultLow   = 250  (低め)
    
    /// 優先度最高。動的に変更可能な最高値。
    static let highest: UILayoutPriority = UILayoutPriority(999)
    /// 優先度最低。動的に変更可能な最低値。
    static let lowest: UILayoutPriority = UILayoutPriority(1)
}
