import Foundation

public extension Array {
    /// 要素を追加する
    static func += ( left: inout Array, right: Element) {
        left.append(right)
    }
}

public extension Array where Element: Equatable {
    
    /// 指定した要素を削除する
    mutating func remove(equatable: Element?) {
        guard let element = equatable, let index: Int = index(of: element) else { return }
        remove(at: index)
    }
    
    /// 指定した全ての要素を削除する
    mutating func removeAll(equatables: [Element]) {
        equatables.forEach {
            remove(equatable: $0)
        }
    }
}

public extension Array where Element: AnyObject {
    
    /// 指定した要素を削除する
    mutating func remove(element: Element?) {
        guard let element = element, let index = index(where: { $0 === element }) else { return }
        remove(at: index)
    }
    
    /// 指定した全ての要素を削除する
    mutating func removeAll(elements: [Element]) {
        elements.forEach {
            remove(element: $0)
        }
    }
}
