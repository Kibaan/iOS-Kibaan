//
//  CoverVertical.swift
//  Kibaan
//
//  Created by altonotes on 2019/01/16.
//  Copyright © 2019 altonotes Inc. All rights reserved.
//

import UIKit

class CoverVertical: TransitionAnimator {
    
    let duration: TimeInterval
    
    init(duration: TimeInterval = 0.32) {
        self.duration = duration
    }
    
    func animateIn(view: UIView?, completion: (() -> Void)?) {
        guard let view = view else { return }
        let topConstant = view.parentConstraints.first { $0.firstAttribute == .top }?.constant ?? 0
        let bottomConstant = view.parentConstraints.first { $0.firstAttribute == .bottom }?.constant ?? 0
        view.belowSuperview()
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            view.parentConstraints.first { $0.firstAttribute == .top }?.constant = topConstant
            view.parentConstraints.first { $0.firstAttribute == .bottom }?.constant = bottomConstant
            view.superview?.layoutIfNeeded()
        }, completion: { result in
            completion?()
        })
    }
    
    func animateOut(view: UIView?, completion: (() -> Void)?) {
        guard let view = view else { return }
        view.layoutIfNeeded()
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            view.belowSuperview()
        }, completion: { result in
            completion?()
        })
    }
}

fileprivate extension UIView {
    
    func belowSuperview() {
        guard let superview = superview else { return }
        let targetAttribute: [NSLayoutConstraint.Attribute] = [.top, .bottom]
        parentConstraints.filter {
            targetAttribute.contains($0.firstAttribute)
        }.forEach {
            $0.constant += superview.frame.height
        }
        superview.layoutIfNeeded()
    }
    
    func fitSuperview() {
        let targetAttribute: [NSLayoutConstraint.Attribute] = [.top, .bottom]
        parentConstraints.filter {
            targetAttribute.contains($0.firstAttribute)
        }.forEach {
            $0.constant = 0
        }
        superview?.layoutIfNeeded()
    }
}
