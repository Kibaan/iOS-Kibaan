import Foundation
import UIKit

public extension NSLayoutConstraint {
    
    /// Multiplierを変更した新しいインスタンスを作成し有効化する
    /// NSLayoutConstraintの multiplierは readonly で変更できないため、multiplierを変えたい場合は新しいインスタンスを作る必要がある
    func setMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        guard let firstItem = firstItem else { return self }
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = shouldBeArchived
        newConstraint.identifier = identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
    
    /// 指定された優先度を設定しつつ、制約を有効化する
    @discardableResult
    func activate(priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        if let priority = priority {
            self.priority = priority
        }
        isActive = true
        return self
    }
}
