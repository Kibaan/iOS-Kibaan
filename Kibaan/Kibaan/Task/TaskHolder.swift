import UIKit

public class TaskHolder {
    
    private var taskList: [Task] = []
    private var taskMap = [String: Task]()

    /// タスクを追加する
    /// キーを指定した場合は既存の同じキーのタスクをキャンセルする
    public func add(_ task: Task, key: String? = nil) {
        
        taskList.append(task)
        
        guard let key = key else { return }
        
        taskMap[key]?.cancel()
        taskMap[key] = task
    }

    /// タスクを削除する
    public func remove(task: Task) {
        taskList.remove(element: task)
        
        let removeKey = taskMap.first { $0.value === task }?.key
        if let removeKey = removeKey {
            taskMap.removeValue(forKey: removeKey)
        }
    }
    
    /// 保持するタスクを全てクリアする
    public func clearAll() {
        taskList.forEach { $0.cancel() }
        taskMap.removeAll()
    }
}
