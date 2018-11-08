//
//  Created by Yamamoto Keita on 2018/03/27.
//

import UIKit

///　非同期でURLから画像を取得する
public class URLImagePicker {
   
    /// URLを指定して画像を取得する
    static public func execute(url: String, onComplete: @escaping (UIImage) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        
        DispatchQueue.global().async {
            if let imageData = try? NSData(contentsOf: url, options: .mappedIfSafe),
                let image = UIImage(data: imageData as Data) {
                DispatchQueue.main.async {
                    onComplete(image)
                }
            }
        }
    }
}
