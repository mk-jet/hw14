import UIKit
import CoreData

class CViewController: UIViewController {
    
    @IBOutlet var taskTableView: UITableView!
    
    @IBAction func addTaskButton(_ sender: Any) {
        let alert = UIAlertController(title: "Add task", message: "What else do you want to do?", preferredStyle: .alert)
        alert.addTextField()
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            let textfield = alert.textFields![0]
            CoreDataTasks.addTaskToPersistance(name: textfield.text!)
        }
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
        CoreDataTasks.fetchTasks()
        reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.dataSource = self
        taskTableView.delegate = self
        taskTableView.separatorColor = UIColor.lightGray
    }
}

extension CViewController: UITableViewDataSource, UITableViewDelegate, CTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CoreDataTasks.fetchTasks()
        let rows = CoreDataTasks.doneTasks().count + CoreDataTasks.undoneTasks().count
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        CoreDataTasks.fetchTasks()
        let cell = taskTableView.dequeueReusableCell(withIdentifier: "CTableViewCell", for: indexPath) as! CTableViewCell

        cell.taskDeleteButton.backgroundColor = UIColor.white
        cell.taskDeleteButton.setImage(UIImage(named: "delete"), for: .normal)
    
        let task = CoreDataTasks.task(row: indexPath.row)

        let taskButtonImage = task.completeness == false ? UIImage(named: "uncheck") : UIImage(named: "check")
        cell.taskDoneButton.tintColor = task.completeness == false ? UIColor.darkGray : UIColor.lightGray
        cell.taskDoneButton.backgroundColor = UIColor.white
        cell.taskDoneButton.setImage(taskButtonImage, for: .normal)

        cell.taskNameTextField.text = task.name
        cell.taskNameTextField.borderStyle = .none
        cell.taskNameTextField.backgroundColor = UIColor.white
        cell.taskNameTextField.textColor = task.completeness == false ? UIColor.black : UIColor.lightGray

        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.taskTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            CoreDataTasks.deleteTask(row: indexPath.row)
            CoreDataTasks.fetchTasks()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func taskDoneButtonTouhced(cell: CTableViewCell) {
        if let row = self.taskTableView.indexPath(for: cell)?.row {
            CoreDataTasks.changeStatus(row: row)
        }
        CoreDataTasks.fetchTasks()
        reload()
    }
    
    func taskNameChanged(cell: CTableViewCell) {
        if let row = self.taskTableView.indexPath(for: cell)?.row {
            CoreDataTasks.changeStatus(row: row)
        }
        CoreDataTasks.fetchTasks()
        reload()
    }
}
