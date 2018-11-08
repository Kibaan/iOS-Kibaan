import UIKit

public extension UIEdgeInsets {
    
    /// ４方向を同一の値で生成する
    init(size: CGFloat) {
        self.init(top: size, left: size, bottom: size, right: size)
    }
    
    /// 指定された割合をかけたUIEdgeInsetsを生成する
    func scaled(_ scale: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: top * scale, left: left * scale, bottom: bottom * scale, right: right * scale)
    }
}
