import Foundation
import CoreData

class CoreDataPersistance {
    var tasksUndone: [NSManagedObject] = []
    var tasksDone: [NSManagedObject] = []

    func addTask(tasksList: String, name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let task = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: tasksList, in: managedContext)!, insertInto: managedContext)
        task.setValue(name, forKeyPath: "name")
      
        do {
            try managedContext.save()
            tasksUndone.append(task)
            tasksDone.append(task)
        } catch let error as NSError { print("Could not save. \(error), \(error.userInfo)") }
    }
    
    func fetchTasks(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchUndone = NSFetchRequest<NSManagedObject>(entityName: "TaskUndone")
        let fetchDone = NSFetchRequest<NSManagedObject>(entityName: "TaskDone")

        do {
            tasksUndone = try managedContext.fetch(fetchUndone)
        } catch let error as NSError {
            print("Could not fetch tasks that Undone. \(error), \(error.userInfo)")
        }
        
        do {
            tasksDone = try managedContext.fetch(fetchDone)
        }
        catch let error as NSError { print("Could not fetch tasks that Done. \(error), \(error.userInfo)") }
    }
    
    func deleteTask(tasksList: String, name: String? = nil, index: Int? = nil){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        if tasksList == "TaskUndone" {
            let objects = tasksUndone as! [TaskUndone]
            if name != nil {
                for task in objects {
                    if task.name == name {
                        managedContext.delete(task)
                        break
                    }
                }
            }
            if index != nil {
                if index! < tasksUndone.count {
                    managedContext.delete(objects[index!])
                }
            }
        } else if tasksList == "TaskDone" {
            let objects = tasksDone as! [TaskDone]
            if name != nil {
                for task in objects {
                    if task.name == name {
                        managedContext.delete(task)
                    }
                }
            }
            if index != nil {
                if index! < tasksDone.count {
                    managedContext.delete(objects[index!])
                }
            }
        }
        do {
            try managedContext.save()
            print("Delete successful")
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    func cleanTask(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        for task in tasksDone {managedContext.delete(task)}
        for task in tasksUndone {managedContext.delete(task)}
        do {
            try managedContext.save()
            print("Cleaned successful")
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    func printTasks(){
        print("Undone tasks (\(tasksUndone.count)):")
        for task in tasksUndone {
            let taskName = task as! TaskUndone
            print("-- \(String(describing: taskName.name))")
        }
        print("Done tasks (\(tasksDone.count)):")
        for task in tasksDone {
            let taskName = task as! TaskDone
            print("-- \(String(describing: taskName.name))")
        }
    }
}
