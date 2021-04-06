import Foundation
import RealmSwift

class Task: Object{
    @objc dynamic var taskName = ""
    @objc dynamic var taskDone = false
}


class Ambry {
    static let shared = Ambry()
    private let tasks = try! Realm()
    
    func addNewTask() {     // Создаём новое невыполненное задание с именем "New Task"
        let newTask = Task()
        newTask.taskName = "New task"
        newTask.taskDone = false
        try! tasks.write {
            tasks.add(newTask)
        }
    }
    
    func undoneTasks() -> [Task] {     // Возвращает массив невыполненных заданий
        var tasksArray: [Task] = []
        for task in tasks.objects(Task.self).filter("taskDone == false") {
            tasksArray.append(task)
        }
        return tasksArray
    }
    
    func doneTasks() -> [Task] {    // Возвращает массив выполненных заданий
        var tasksArray: [Task] = []
        for task in tasks.objects(Task.self).filter("taskDone == true") {
            tasksArray.append(task)
        }
        return tasksArray
    }
    
    func changeStatus(section: Int, name: String) {   // Меняет статус задания (выполено/нет)
        if section == 0 {
            try! tasks.write {
                for task in tasks.objects(Task.self).filter("taskDone == false") {
                    if task.taskName == name {
                        task.taskDone = !task.taskDone
                        break
                    }
                }
            }
        } else if section == 1 {
            try! tasks.write {
                for task in tasks.objects(Task.self).filter("taskDone == true") {
                    if task.taskName == name {
                        task.taskDone = !task.taskDone
                        break
                    }
                }
            }
        }
    }
    
    func changeName(section: Int, row: Int, newName: String) {  // Меняет имя задания
        if section == 0 {
            let oldString = undoneTasks()[row].taskName
            for (index, task) in tasks.objects(Task.self).enumerated(){
                if task.taskName == oldString && task.taskDone == false{
                    try! tasks.write {
                        tasks.objects(Task.self)[index].taskName = newName
                    }
                    break
                }
            }
        } else if section == 1 {
            let oldString = doneTasks()[row].taskName
            for (index, task) in tasks.objects(Task.self).enumerated(){
                if task.taskName == oldString && task.taskDone == true {
                    try! tasks.write {
                        tasks.objects(Task.self)[index].taskName = newName
                    }
                    break
                }
            }
        }
    }
    
    func deleteTask(section: Int, name: String) {   // Удаляет задание
        let doneStatus = section == 0 ? false : true
        for (index,task) in tasks.objects(Task.self).enumerated(){
            if task.taskName == name && task.taskDone == doneStatus {
                try! Ambry.shared.tasks.write {
                    Ambry.shared.tasks.delete(Ambry.shared.tasks.objects(Task.self)[index])
                }
                break
            }
        }
    }
}
