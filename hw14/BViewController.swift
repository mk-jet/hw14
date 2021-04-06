import UIKit
//import RealmSwift

class BViewController: UIViewController {
    
    @IBOutlet var taskTableView: UITableView!

    @IBAction func addTaskButton(_ sender: Any) {
        Ambry.shared.addNewTask()
        self.taskTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.separatorColor = UIColor.lightGray
    }
}

extension BViewController: UITableViewDataSource, UITableViewDelegate, BTableViewCellDelegate {

    func numberOfSections(in tableView: UITableView) -> Int { return 2 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? Ambry.shared.undoneTasks().count : Ambry.shared.doneTasks().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTableView.dequeueReusableCell(withIdentifier: "BTableViewCell", for: indexPath) as! BTableViewCell

        cell.taskDeleteButton.backgroundColor = UIColor.white
        cell.taskDeleteButton.setImage(UIImage(named: "delete"), for: .normal)

        let section = indexPath.section == 0 ? Ambry.shared.undoneTasks() : Ambry.shared.doneTasks()
        let task = section[indexPath.row].taskName

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

    func taskDoneButtonTouched(cell: BTableViewCell) {
        if let name = cell.taskNameTextField.text {
            if let section = self.taskTableView.indexPath(for: cell)?.section {
                Ambry.shared.changeStatus(section: section, name: name)
            }
        }
        self.taskTableView.reloadData()
    }

    func taskNameChanged(cell: BTableViewCell) {
        if let newName = cell.taskNameTextField.text {
            if let section = self.taskTableView.indexPath(for: cell)?.section {
                if let row = self.taskTableView.indexPath(for: cell)?.row {
                    Ambry.shared.changeName(section: section, row: row, newName: newName)
                }
            }
        }
        self.taskTableView.reloadData()
    }
    

    func taskDeleteButtonTouched(cell: BTableViewCell) {
        if let section = self.taskTableView.indexPath(for: cell)?.section {
            if let name = cell.taskNameTextField.text {
                Ambry.shared.deleteTask(section: section, name: name)
            }
        }
        self.taskTableView.reloadData()
    }
}
