import UIKit
import Foundation
import CoreData

@objc(CoreDataTasks)
public class CoreDataTasks: NSManagedObject {


//    static let shared = CoreDataTasks()
//    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//    private let context = NSManagedObjectContex t()
//    private var tasks: [CoreDataTasks]?
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Надо ли?!
    private var tasks: [CoreDataTasks] = []
    
    public func fetchTasks() -> [CoreDataTasks] {
            tasks = try! context.fetch(CoreDataTasks.fetchRequest())
        return tasks
    }
    
    public func addTaskToPersistance(name: String) {
        let newTask = CoreDataTasks(context: context)
        newTask.name = name
        newTask.completeness = false
        
        do {
            try self.context.save()
        } catch {
            print(error)
        }
            
//            try managedContext.save()
//            tasksUndone.append(task)
//            tasksDone.append(task)
//        } catch let error as NSError { print("Could not save. \(error), \(error.userInfo)") }
    }
    
    
        
}
