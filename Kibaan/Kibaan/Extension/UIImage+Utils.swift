import UIKit

public extension UIImage {
    
    /// 指定した色で塗りつぶした画像を作成する
    class func makeColorImage(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(origin: .zero, size: size)
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        if let cgImage = context.makeImage() {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
}
