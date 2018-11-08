//
//  CustomNibView.swift
//
//  Created by 山本敬太 on 2016/02/04.
//

import UIKit

/// XIBを自動でロードするView
/// 基本はクラスメイト同名のXIBを読み込むが、xibNameをoverrideして任意のXIBファイルを読み込ませることが出来る
open class CustomNibView: CustomView {

    @IBOutlet open var contentView: UIView!
    
    open var xibName: String? { return nil }

    override open func commonInit() {
        super.commonInit()
        
        let fullName = NSStringFromClass(type(of: self))
        if let xibName = self.xibName ?? fullName.components(separatedBy: ".").last {
            let bundle = Bundle(for: type(of: self))
            bundle.loadNibNamed(xibName, owner: self, options: nil)
        }
        addSubview(contentView)
        
        // 引数なしコンストラクタで作成された場合、サイズが0になるためxibのサイズを引き継ぐ
        frame.size = contentView.frame.size
        
        AutoLayoutUtils.fit(contentView, superView: self)
        backgroundColor = .clear
    }
}
