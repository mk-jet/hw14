import UIKit
import CoreData

class CViewController: UIViewController {
    
    var tasksUndone: [NSManagedObject] = []
    var tasksDone: [NSManagedObject] = []
    
    @IBOutlet var taskTableView: UITableView!
    
    @IBAction func addTaskButton(_ sender: Any) {
        fetchTasks()
        addTask(tasksList: "TaskUndone", name: "New task")
        fetchTasks()
        taskTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.separatorColor = UIColor.lightGray
    }
}

extension CViewController: UITableViewDataSource, UITableViewDelegate, CTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchTasks()
        return section == 0 ? tasksUndone.count : tasksDone.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fetchTasks()
        let cell = taskTableView.dequeueReusableCell(withIdentifier: "CTableViewCell", for: indexPath) as! CTableViewCell
        var task: String? = nil

        cell.taskDeleteButton.backgroundColor = UIColor.white
        cell.taskDeleteButton.setImage(UIImage(named: "delete"), for: .normal)
    
        if indexPath.section == 0 {
            let tasks = tasksUndone as! [TaskUndone]
            task = tasks[indexPath.row].name
        } else {
            let tasks = tasksDone as! [TaskDone]
            task = tasks[indexPath.row].name
        }

        let taskButtonImage = indexPath.section == 0 ? UIImage(named: "uncheck") : UIImage(named: "check")
        cell.taskDoneButton.tintColor = indexPath.section == 0 ? UIColor.darkGray : UIColor.lightGray
        cell.taskDoneButton.backgroundColor = UIColor.white
        cell.taskDoneButton.setImage(taskButtonImage, for: .normal)

        cell.taskNameTextField.text = task
        cell.taskNameTextField.borderStyle = .none
        cell.taskNameTextField.backgroundColor = UIColor.white
        cell.taskNameTextField.textColor = indexPath.section == 0 ? UIColor.black : UIColor.lightGray

        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func taskDoneButtonTouhced(cell: CTableViewCell) {
        fetchTasks()
        let text = cell.taskNameTextField.text ?? ""
        if self.taskTableView.indexPath(for: cell)?.section == 0 {
            addTask(tasksList: "TaskDone", name: text)
            deleteTask(tasksList: "TasksUndone", name: text)
        } else if self.taskTableView.indexPath(for: cell)?.section == 1 {
            addTask(tasksList: "TaskUndone", name: text)
            deleteTask(tasksList: "TasksDone", name: text)
        }
        fetchTasks()
        self.taskTableView.reloadData()
    }
    
    func taskNameChanged(cell: CTableViewCell) {
        fetchTasks()
        let text = cell.taskNameTextField.text ?? ""
        if self.taskTableView.indexPath(for: cell)?.section == 0 {
            deleteTask(tasksList: "TasksUndone", index: self.taskTableView.indexPath(for: cell)?.row)
            addTask(tasksList: "TasksUndone", name: text)
        } else if self.taskTableView.indexPath(for: cell)?.section == 1 {
            deleteTask(tasksList: "TasksDone", index: self.taskTableView.indexPath(for: cell)?.row)
            addTask(tasksList: "TasksDone", name: text)
        }
        fetchTasks()
        self.taskTableView.reloadData()
    }
    
    func taskDeleteButtonTouched(cell: CTableViewCell) {
        fetchTasks()
        guard let cellIndex = self.taskTableView.indexPath(for: cell) else {return}
        print(cellIndex.section, cellIndex.row)
        if cellIndex.section == 0 {
            deleteTask(tasksList: "TasksUndone", index: cellIndex.row)
        } else if cellIndex.section == 1 {
            deleteTask(tasksList: "TasksDone", index: cellIndex.row)
        }
        fetchTasks()
        self.taskTableView.reloadData()
    }
    
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
}
