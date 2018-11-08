//
//  TaskSet.swift
//  iOSTemplate
//
//  Created by Yamamoto Keita on 2018/07/17.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import Foundation

/// 複数タスクの完了待ちのためのクラス
public class TaskSet: TaskObserver {
    
    private var tasks: [Task] = []
    
    private var onAllCompleted:(() -> Void)?
    private var onAnyError:(() -> Void)?

    private let lockQueue = DispatchQueue(label: "TaskSet serial queue")
    
    private var hasError = false
    
    public func add(_ task: Task) {
        tasks.append(task)
        task.observers.append(self)
    }
    
    public func cancelAll() {
        tasks.forEach { $0.cancel() }
    }
    
    public func clearAll() {
        cancelAll()
        tasks.removeAll()
    }
    
    public func allCompleted(_ onAllCompleted: @escaping () -> Void) {
        self.onAllCompleted = onAllCompleted
    }
    
    public func anyError(onAnyError: @escaping () -> Void) {
        self.onAnyError = onAnyError
    }
    
    // protocol
    
    public func onComplete(task: Task) {
        lockQueue.sync {
            tasks.remove(element: task)
            if tasks.isEmpty && !hasError {
                onAllCompleted?()
            }
        }
    }
    
    public func onError(task: Task) {
        lockQueue.sync {
            tasks.remove(element: task)
            if !hasError {
                hasError = true
                onAnyError?()
            }
        }
    }
    
    public func onEnd(task: Task) {
    }
}
