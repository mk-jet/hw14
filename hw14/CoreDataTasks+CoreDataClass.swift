import UIKit
import Foundation
import CoreData

@objc(CoreDataTasks)
public class CoreDataTasks: NSManagedObject {

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var tasks: [CoreDataTasks] = []
    
    func fetchTasks() {
        do {
            let request = CoreDataTasks.fetchRequest() as NSFetchRequest<CoreDataTasks>
            let sort1 = NSSortDescriptor(key: "completeness", ascending: true)
            let sort2 = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort1, sort2]
            self.tasks = try context.fetch(request)
        } catch { print (error) }
    }
    
    func undoneTasks() -> [CoreDataTasks] {     // Возвращает массив невыполненных заданий
        do {
            let request = CoreDataTasks.fetchRequest() as NSFetchRequest<CoreDataTasks>
            let predicate = NSPredicate(format: "completeness CONTAINS %@", "false")
            request.predicate = predicate
            self.tasks = try context.fetch(request)
        } catch { print (error) }
        return tasks 
    }
    
    func doneTasks()-> [CoreDataTasks] {     // Возвращает массив выполненных заданий
        do {
            let request = CoreDataTasks.fetchRequest() as NSFetchRequest<CoreDataTasks>
            let predicate = NSPredicate(format: "completeness CONTAINS %@", "true")
            request.predicate = predicate
            self.tasks = try context.fetch(request)
        } catch { print (error) }
        return tasks
    }
     
    func addTaskToPersistance(name: String) {
        let newTask = CoreDataTasks(context: context)
        newTask.name = name
        newTask.completeness = false
        do {
            try self.context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteTask(row: Int) {   // Удаляет задание
        do {
            context.delete(tasks[row])
            try context.save()
        } catch { print(error) }
    }
    
    func changeStatus (row: Int) {   // Меняет статус задания (выполено/нет)
        do {
            tasks[row].completeness = !tasks[row].completeness
            try context.save()
        } catch { print(error) }
    }
    
    func changeName (row: Int, name: String?) {   // Меняет название задания
        do {
            tasks[row].name = name ?? ""
            try context.save()
        } catch { print(error) }
    }
    
    func task (row: Int) -> CoreDataTasks { // Возвращает задание
        fetchTasks()
        return tasks[row]
    }
}
