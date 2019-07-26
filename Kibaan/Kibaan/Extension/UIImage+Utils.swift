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

    /// 引数に指定した範囲の部分画像を作成する
    func createSubImage(rect: CGRect) -> UIImage {
        let screenScale = UIScreen.main.scale
        let scaledRect = CGRect(x: rect.origin.x * screenScale,
                                y: rect.origin.y * screenScale,
                                width: rect.width * screenScale,
                                height: rect.height * screenScale)
        guard let cgImage = cgImage?.cropping(to: scaledRect) else {
            return self
        }
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
}
