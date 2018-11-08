//
//  Created by 山本 敬太 on 2014/12/27.
//

import UIKit

/// 一つだけ選択可能なボタンのグループ。ボタンと値のセットを複数登録して使用する。
/// 登録されたボタンの中の一つを選択状態にすることができ、選択されたボタンに紐づく値を取得できる。
/// また、値を設定するとそれに紐づくボタンが選択状態になる。
open class ButtonGroup<T: Equatable> {

    /// ボタンと値のマップ
    private var buttonValueMap: [UIButton: T] = [:]

    /// 選択されたボタンに紐づく値
    open var selectedValue: T? {
        didSet {
            for (button, value) in buttonValueMap {
                button.isSelected = (value == selectedValue)
            }
        }
    }
    
    /// 値のリスト
    open var values: [T] {
        return buttonValueMap.map { $0.value }
    }
    
    public init() {}
    
    /// 登録されたボタンの情報をクリアする
    open func clear() {
        buttonValueMap.removeAll(keepingCapacity: true)
    }

    /// ボタンとそれに紐づく値を登録する
    open func register(_ button: UIButton, value: T) {
        buttonValueMap[button] = value
    }

    /// 指定したボタンを選択する
    open func select(button: UIButton) {
        selectedValue = buttonValueMap[button]
    }
    
    /// 指定した値に紐づくボタンを選択する
    open func select(type: T) {
        selectedValue = type
    }
    
    /// 指定した値に紐づくボタンを取得する
    open func get(_ value: T) -> UIButton? {
        return buttonValueMap.filter { $0.value == value }.map { $0.key }.first
    }
}
