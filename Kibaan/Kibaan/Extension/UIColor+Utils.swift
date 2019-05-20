import UIKit

public extension UIColor {
    
    /// 16進数のカラーコードとアルファ（不透明度）を指定して色を作成する
    /// ex. UIColor(rgbValue: 0x171b35)
    convenience init(rgbValue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat( rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha))
    }

    /// 16進数のカラーコード文字列とアルファ（不透明度）を指定して色を作成する
    /// ex. UIColor(rgbValue: "#FF9900")
    convenience init(rgbHex: String, alpha: CGFloat = 1.0) {
        let code = rgbHex.removePrefix("#")
        guard code.count == 6,
            let rStr = code[0...1],
            let gStr = code[2...3],
            let bStr = code[4...5] else {
            self.init(white: 0, alpha: 1)
            return
        }

        let r = CGFloat(Int(rStr, radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(gStr, radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(bStr, radix: 16) ?? 0) / 255.0
        self.init(
            red: r,
            green: g,
            blue: b,
            alpha: alpha)
    }

    /// 16進数のカラーコード文字列（α含む）を指定して色を作成する
    /// ex. UIColor(rgbValue: "#FF9900")
    convenience init(argbHex: String) {
        var code = argbHex.removePrefix("#")
        var alpha: CGFloat = 1.0

        if code.count == 8, let aStr = code[0...1] {
            code = code.substring(from: 2) ?? ""
            alpha = CGFloat(Int(aStr, radix: 16) ?? 0) / 255.0
        }

        self.init(rgbHex: code, alpha: alpha)
    }

    /// 明度を上げた色を作成する
    func whiteAdded(_ value: CGFloat) -> UIColor {
        let color = CIColor(cgColor: self.cgColor)
        
        let red = max(min(color.red + value, 1.0), 0.0)
        let green = max(min(color.green + value, 1.0), 0.0)
        let blue = max(min(color.blue + value, 1.0), 0.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: color.alpha)
    }

    /// 文字列のカラーコード（アルファは含まない）
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
    
    /// 指定された数値を16進数の文字列に変換して返す
    private func hexString(_ value: CGFloat) -> String {
        return String(format: "%02hhX", Int(value))
    }
}
