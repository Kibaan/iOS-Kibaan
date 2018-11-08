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
    
    /// 幅
    var width: CGFloat {
        get { return size.width }
        set(value) { size.width = value }
    }
    
    /// 高さ
    var height: CGFloat {
        get { return size.height }
        set(value) { size.height = value }
    }
    
    /// X座標
    var x: CGFloat {
        get { return origin.x }
        set(value) { origin.x = value }
    }
    
    /// Y座標
    var y: CGFloat {
        get { return origin.y }
        set(value) { origin.y = value }
    }
}
