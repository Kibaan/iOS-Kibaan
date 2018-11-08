//
//  AutoLayoutUtils.swift
//
//  Created by 山本 敬太 on 2015/05/16.
//

import UIKit

public struct ConstraintInfo {
    public var table: [NSLayoutConstraint.Attribute: NSLayoutConstraint] = [:]
    
    // [] 演算子定義
    public subscript(key: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        get {
            return table[key]
        }
        set(value) {
            table[key] = value
        }
    }
}

/// オートレイアウトを行う
public class AutoLayoutUtils {

    // MARK: - レイアウト

    /// 親Viewを基準にセンタリングする
    @discardableResult
    static public func center(_ view: UIView, superView: UIView) -> [NSLayoutConstraint] {
        let constraints = centerConstraints(view, superView: superView)
        view.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(constraints)
        
        return constraints
    }
    
    /// 親Viewに合わせる
    @discardableResult
    static public func fit(_ view: UIView, superView: UIView) -> [NSLayoutConstraint] {
        let constraints = fitConstraints(view, superView: superView)
        view.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(constraints)
        
        return constraints
    }

    /// 横幅と高さを親Viewに合わせる
    @discardableResult
    static public func sameSize(_ view: UIView, superView: UIView) -> [NSLayoutConstraint] {
        let constraints = sameSizeConstraints(view, superView: superView)
        view.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(constraints)
        return constraints
    }
    
    /// 横幅を親Viewに合わせる
    @discardableResult
    static public func sameWidth(_ view: UIView, superView: UIView) -> NSLayoutConstraint {
        let constraint = equalConstraint(view, superView: superView, attribute: .width)
        view.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(constraint)
        return constraint
    }
    
    /// 横幅と高さおよびTop位置を親Viewに合わせる
    @discardableResult
    static public func sameSizeAndTop(_ view: UIView, superView: UIView) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let sizeConstraints = sameSize(view, superView: superView)
        let topConstraint = equalConstraint(view, superView: superView, attribute: .top)
        superView.addConstraint(topConstraint)
        
        return sizeConstraints + [topConstraint]
    }
    
    /// 横幅と高さおよびTop位置とLeft位置を親Viewに合わせる
    @discardableResult
    static public func sameSizeAndTopLeft(_ view: UIView, superView: UIView) -> ConstraintInfo {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let sizeConstraints = sameSize(view, superView: superView)
        let topConstraint = equalConstraint(view, superView: superView, attribute: .top)
        let leftConstraint = equalConstraint(view, superView: superView, attribute: .left)
        superView.addConstraint(topConstraint)
        superView.addConstraint(leftConstraint)
        
        var result = ConstraintInfo()
        result[.top] = topConstraint
        result[.left] = leftConstraint
        result[.width] = sizeConstraints[0]
        result[.height] = sizeConstraints[1]

        return result
    }

    /// Viewの高さをアスペクト比を保って設定する
    static public func fixAspectRatio(_ view: UIView, width: CGFloat, height: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false

        let constraint = NSLayoutConstraint(
            item: view,
            attribute: .height,
            relatedBy: .equal,
            toItem: view,
            attribute: .width,
            multiplier: height / width,
            constant: 0)
        
        NSLayoutConstraint.activate([constraint])
    }
    
    // MARK: - Constraintセットの作成

    /// 親Viewを基準にセンタリングするConstraintsを作成
    static public func centerConstraints(_ view: UIView, superView: UIView) -> [NSLayoutConstraint] {
        
        var list: [NSLayoutConstraint] = []
        var constraint: NSLayoutConstraint
        
        // centerX
        constraint = equalConstraint(view, superView: superView, attribute: .centerX)
        list += [constraint]
        
        // centerY
        constraint = equalConstraint(view, superView: superView, attribute: .centerY)
        list += [constraint]
        
        return list
    }
    
    /// 親Viewの全面に同サイズで配置するConstraintsを作成
    static public func fitConstraints(_ view: UIView, superView: UIView) -> [NSLayoutConstraint] {
        
        var list: [NSLayoutConstraint] = []
        var constraint: NSLayoutConstraint
        
        // top
        constraint = equalConstraint(view, superView: superView, attribute: .top)
        list += [constraint]
        
        // bottom
        constraint = equalConstraint(view, superView: superView, attribute: .bottom)
        list += [constraint]
        
        // left
        constraint = equalConstraint(view, superView: superView, attribute: .left)
        list += [constraint]
        
        // right
        constraint = equalConstraint(view, superView: superView, attribute: .right)
        list += [constraint]
        
        return list
    }
    
    /// 親Viewと同サイズとするConstraintsを作成
    static public func sameSizeConstraints(_ view: UIView, superView: UIView) -> [NSLayoutConstraint] {
        var list: [NSLayoutConstraint] = []
        var constraint: NSLayoutConstraint
        
        // width
        constraint = equalConstraint(view, superView: superView, attribute: .width)
        list += [constraint]
        
        // height
        constraint = equalConstraint(view, superView: superView, attribute: .height)
        list += [constraint]
        
        return list
    }
    
    /// 親Viewの最下部に親Viewと同じ横幅で配置するConstraintsを作成
    static public func bottomFitConstraints(_ view: UIView, superView: UIView) -> [NSLayoutConstraint] {
        
        var list: [NSLayoutConstraint] = []
        var constraint: NSLayoutConstraint

        // bottom
        constraint = equalConstraint(view, superView: superView, attribute: .bottom)
        list += [constraint]

        // height
        constraint = fixedConstraint(view, attribute: .height, value: view.frame.size.height)
        list += [constraint]

        // width
        constraint = equalConstraint(view, superView: superView, attribute: .width)
        list += [constraint]
        
        return list
    }

    // MARK: - Constraintの作成

    /// 親Viewに合わせるConstraintsを作成
    static public func equalConstraint(_ view: UIView, superView: UIView, attribute: NSLayoutConstraint.Attribute, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint(item: view,
                                            attribute: attribute,
                                            relatedBy: NSLayoutConstraint.Relation.equal,
                                            toItem: superView,
                                            attribute: attribute,
                                            multiplier: 1,
                                            constant: constant)
        
        return constraint
    }
    
    /// 固定値のConstraintsを作成
    static public func fixedConstraint(_ view: UIView, attribute: NSLayoutConstraint.Attribute, value: CGFloat) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint(item: view,
                                            attribute: attribute,
                                            relatedBy: NSLayoutConstraint.Relation.equal,
                                            toItem: nil,
                                            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                            multiplier: 1,
                                            constant: value)
        
        return constraint
    }
    
    // MARK: - Constraintの更新
    
    /// 指定した属性の固定値を更新する
    static public func updateFixedConstraint(_ view: UIView, attribute: NSLayoutConstraint.Attribute, value: CGFloat) {
        let constraints = view.constraints.filter { $0.firstAttribute == attribute }
        if let constraint = constraints.first {
            constraint.constant = value
        }
    }
}
