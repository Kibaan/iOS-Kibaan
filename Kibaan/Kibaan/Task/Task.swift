//
//  Task.swift
//  iOSTemplate
//
//  Created by Yamamoto Keita on 2018/07/17.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import Foundation

open class Task {
    
    /// タスクの所有者
    weak open var owner: TaskHolder?
    /// タスクの監視者
    open var observers: [TaskObserver] = []
    
    /// 後処理
    private var nextProcess: (() -> Void)?
    /// 後処理のディレイ時間
    private var nextProcessDelaySec: Double = 0
    /// 後処理のタイマー
    private var nextProcessTimer: Timer?
    
    /// 完了処理
    var finishHandler: (() -> Void)?
    
    public init() {}
    
    public init(owner: TaskHolder, key: String?) {
        self.owner = owner
        owner.add(self, key: key)
    }
    
    /// 開始
    open func start() {}
    
    open func cancel() {
        nextProcessTimer?.invalidate()
        nextProcessTimer = nil
        end()
    }
    
    open func onFinish(_ action: (() -> Void)?) {
        finishHandler = action
    }
    
    open func setNextProcess(delaySec: Double, process: @escaping () -> Void) {
        nextProcess = process
        nextProcessDelaySec = delaySec
    }
    
    open func end() {
        observers.forEach {[unowned self] in
            $0.onEnd(task: self)
        }
        observers.removeAll()
        
        if nextProcessTimer == nil {
            owner?.remove(task: self)
        }
    }
    
    open func error() {
        observers.forEach {[unowned self] in
            $0.onError(task: self)
        }
    }

    open func complete() {
        observers.forEach {[unowned self] in
            $0.onComplete(task: self)
        }
    }

    open func next() {
        if nextProcess != nil {
            let timer = Timer(timeInterval: nextProcessDelaySec,
                              target: self,
                              selector: #selector(nextProcessTimerTask),
                              userInfo: nil, repeats: false)
            nextProcessTimer = timer
            RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        }
    }
    
    @objc func nextProcessTimerTask() {
        owner?.remove(task: self)
        nextProcess?()
    }
}

public protocol TaskObserver: class {
    func onComplete(task: Task)
    func onError(task: Task)
    func onEnd(task: Task)
}
