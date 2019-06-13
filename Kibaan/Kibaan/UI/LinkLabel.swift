//
//  LinkLabel.swift
//
//  Created by Akira Nakajima on 2018/08/06.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import UIKit

open class LinkLabel: SmartLabel {
    
    // MARK: - Inner Class

    public class LinkInfo {
        public var range: NSRange
        public var onTap: ((LinkInfo) -> Void)?
        public var rangeList: [NSRange]
        
        public init(range: NSRange, onTap: ((LinkInfo) -> Void)? = nil) {
            self.range = range
            self.onTap = onTap
            self.rangeList = (0..<range.length).enumerated().map {
                return NSRange(location: range.lowerBound + $0.offset, length: 1)
            }
        }
    }
    
    // MARK: - Variables
    
    open var linkList = [LinkInfo]()
    open var tapRecognizer: UITapGestureRecognizer?
    
    // MARK: - Functions
    
    /// テキストの任意位置にリンクを設定する。複数設定可能
    open func setLinks(linkList: [LinkInfo], color: UIColor) {
        guard let text = text else {
            return
        }
        self.linkList = linkList
        
        let attrStr = NSMutableAttributedString(string: text, attributes: [.font: font as Any])
        linkList.forEach {link in
            attrStr.addAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue,
                                   .foregroundColor: color], range: link.range)
        }
        attributedText = attrStr
        
        // ジェスチャの追加
        if tapRecognizer == nil {
            isUserInteractionEnabled = true
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(_:)))
            addGestureRecognizer(tapRecognizer)
        }
    }
    
    /// 指定した文字列一箇所にリンクを設定する
    open func setLinkText(_ linkText: String, color: UIColor, onTap: (() -> Void)? = nil) {
        guard let text = text else {
            return
        }
        
        let range = (text as NSString).range(of: linkText)
        let linkInfo = LinkInfo(range: range) {link in
            onTap?()
        }
        
        setLinks(linkList: [linkInfo], color: color)
    }
    
    @objc private func tapGesture(_ recognizer: UITapGestureRecognizer) {
        guard let attributedText = attributedText else { return }
        let touchPoint = recognizer.location(in: self)
        
        let textContainer = NSTextContainer(size: frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        
        let layoutManager = NSLayoutManager()
        layoutManager.usesFontLeading = false
        layoutManager.addTextContainer(textContainer)
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addLayoutManager(layoutManager)
        
        let glyphRectMargin: CGFloat = self.glyphRectMargin
        let targetLink = linkList.first(where: { link in
            link.rangeList.contains(where: { range in
                let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
                var glyphRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
                glyphRect.origin.y += glyphRectMargin
                return glyphRect.contains(touchPoint) && link.onTap != nil
            })
        })
        if let link = targetLink, let onTap = link.onTap {
            onTap(link)
        }
    }
    
    private var glyphRectMargin: CGFloat {
        guard let text = text else { return 0 }
        let boundingRect = NSString(string: text).boundingRect(with: bounds.size, options: .usesLineFragmentOrigin, attributes: [.font: font as Any], context: nil)
        return (frame.height - boundingRect.height) / 2
    }
}
