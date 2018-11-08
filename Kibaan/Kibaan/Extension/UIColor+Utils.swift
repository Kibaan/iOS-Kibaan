import UIKit

public extension UIColor {
    
    /// 16進数のカラーコードとアルファ（不透明度）を指定して色を作成する
    /// UIColor(rgbValue: 0x171b35)
    convenience init(rgbValue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat( rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha))
    }
    
    /// 明度を上げた色を作成する
    func whiteAdded(_ value: CGFloat) -> UIColor {
        let color = CIColor(cgColor: self.cgColor)
        
        let red = min(color.red + value, 1.0)
        let green = min(color.green + value, 1.0)
        let blue = min(color.blue + value, 1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: color.alpha)
    }

    var colorCode: String? {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        red *= 255.0
        green *= 255.0
        blue *= 255.0
        return hexString(red) + hexString(green) + hexString(blue)
    }
    
    private func hexString(_ value: CGFloat) -> String {
        return String(format: "%02hhX", Int(value))
    }
}
