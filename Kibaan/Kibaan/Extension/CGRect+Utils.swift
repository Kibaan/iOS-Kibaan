import Foundation
import UIKit

public extension CGRect {
    
    /// 短辺の長さ
    var shortLength: CGFloat {
        return min(width, height)
    }
    
    /// 長辺の長さ
    var longLength: CGFloat {
        return max(width, height)
    }
}
