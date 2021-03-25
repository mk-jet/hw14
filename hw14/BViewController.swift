import UIKit
import RealmSwift

class BViewController: UIViewController {
    
    @IBOutlet var taskTableView: UITableView!

    @IBAction func addTaskButton(_ sender: Any) {
        let newTask = Task()
        newTask.taskName = "New task"
        newTask.taskDone = false
        try! Ambry.shared.tasks.write {
            Ambry.shared.tasks.add(newTask)
        }
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
        return section == 0 ? Ambry.shared.tasks.objects(Task.self).filter("taskDone == false").count : Ambry.shared.tasks.objects(Task.self).filter("taskDone == true").count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTableView.dequeueReusableCell(withIdentifier: "BTableViewCell", for: indexPath) as! BTableViewCell

        cell.taskDeleteButton.backgroundColor = UIColor.white
        cell.taskDeleteButton.setImage(UIImage(named: "delete"), for: .normal)

        let section = indexPath.section == 0 ? Ambry.shared.tasks.objects(Task.self).filter("taskDone == false") : Ambry.shared.tasks.objects(Task.self).filter("taskDone == true")
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
        if let currentTask = cell.taskNameTextField.text {
            try! Ambry.shared.tasks.write {
                for task in Ambry.shared.tasks.objects(Task.self){
                    if task.taskName == currentTask {
                        task.taskDone = !task.taskDone
                        break
                    }
                }
            }
        }
        self.taskTableView.reloadData()
    }

    func taskNameChanged(cell: BTableViewCell) {
        // Полагаю, есть гораздо более элегантное решение, но я ничего лучше не придумал
        if let index = self.taskTableView.indexPath(for: cell) {
            if index.section == 0 {
                let undoneTasks = Ambry.shared.tasks.objects(Task.self).filter("taskDone == false")
                var oldString = ""
                for (counter,_) in undoneTasks.enumerated(){
                    if counter == index.row {
                        oldString = undoneTasks[counter].taskName
                    }
                }
                for (counter,task) in Ambry.shared.tasks.objects(Task.self).enumerated(){
                    if task.taskName == oldString {
                        try! Ambry.shared.tasks.write {
                            Ambry.shared.tasks.objects(Task.self)[counter].taskName = cell.taskNameTextField.text ?? ""
                        }
                        break
                    }
                }
            } else {
                let doneTasks = Ambry.shared.tasks.objects(Task.self).filter("taskDone == true")
                var oldString = ""
                for (counter,_) in doneTasks.enumerated(){
                    if counter == index.row {
                        oldString = doneTasks[counter].taskName
                    }
                }
                
                for (counter,task) in Ambry.shared.tasks.objects(Task.self).enumerated(){
                    if task.taskName == oldString {
                        try! Ambry.shared.tasks.write {
                            Ambry.shared.tasks.objects(Task.self)[counter].taskName = cell.taskNameTextField.text ?? ""
                        }
                        break
                    }
                }
            }
            self.taskTableView.reloadData()
        }
    }
    

    func taskDeleteButtonTouched(cell: BTableViewCell) {
        if let currentTask = cell.taskNameTextField.text {
            for (index,task) in Ambry.shared.tasks.objects(Task.self).enumerated(){
                if task.taskName == currentTask {
                    try! Ambry.shared.tasks.write {
                        Ambry.shared.tasks.delete(Ambry.shared.tasks.objects(Task.self)[index])
                    }
                    break
                }
            }
        }
        self.taskTableView.reloadData()
    }
}
