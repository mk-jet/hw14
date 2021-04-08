import UIKit

class CViewController: UIViewController {
    
    let coreTasks = CoreDataTasks()
    
    @IBOutlet var taskTableView: UITableView!
    
    @IBAction func addTaskButton(_ sender: Any) {
        let alert = UIAlertController(title: "Add task", message: "What else do you want to do?", preferredStyle: .alert)
        alert.addTextField()
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            let textfield = alert.textFields![0]
            self.coreTasks.addTaskToPersistance(name: textfield.text!)
            self.coreTasks.fetchTasks()
            self.reload()
        }
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
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
        return coreTasks.quantityOfTasks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        coreTasks.fetchTasks()
        let cell = taskTableView.dequeueReusableCell(withIdentifier: "CTableViewCell", for: indexPath) as! CTableViewCell

        let task = coreTasks.task(row: indexPath.row)
        
        cell.taskDoneButton.backgroundColor = UIColor.white
        cell.taskDoneButton.tintColor = task.completeness == false ? UIColor.darkGray : UIColor.lightGray
        let taskButtonImage = task.completeness == false ? UIImage(named: "uncheck") : UIImage(named: "check")
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
            self.coreTasks.deleteTask(row: indexPath.row)
            self.coreTasks.fetchTasks()
            self.reload()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func taskDoneButtonTouhced(cell: CTableViewCell) {
        if let row = self.taskTableView.indexPath(for: cell)?.row {
            coreTasks.changeStatus(row: row)
        }
        coreTasks.fetchTasks()
        reload()
    }
    
    func taskNameChanged(cell: CTableViewCell) {
        if let row = self.taskTableView.indexPath(for: cell)?.row {
            if let name = cell.taskNameTextField.text {
                coreTasks.changeName(row: row, name: name)
            }
        }
        coreTasks.fetchTasks()
        reload()
    }
}
