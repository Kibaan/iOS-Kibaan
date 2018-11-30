//
//  Created by Yamamoto Keita on 2018/08/08.
//

import Foundation

public struct KeyValue {
    public var key: String
    public var value: String?
    
    public var stringValue: String {
        if let value = value {
            return "\(key)=\(value)"
        } else {
            return key
        }
    }
    
    public init(key: String, value: String?) {
        self.key = key
        self.value = value
    }
}
