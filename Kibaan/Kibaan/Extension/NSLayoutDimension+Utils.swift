import UIKit

public extension NSLayoutDimension {
    
    /// レイアウト制約を作成して有効化する
    @discardableResult
    func activateConstraint(equalToConstant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let const = constraint(equalToConstant: equalToConstant)
        const.priority = priority
        const.isActive = true
        return const
    }
}
