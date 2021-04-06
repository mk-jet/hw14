import UIKit

protocol BTableViewCellDelegate: Any {
    func taskDoneButtonTouched (cell: BTableViewCell)
    func taskNameChanged (cell: BTableViewCell)
    func taskDeleteButtonTouched (cell: BTableViewCell)
}

class BTableViewCell: UITableViewCell {
    var delegate: BTableViewCellDelegate?
    
    @IBOutlet var taskDoneButton: UIButton!
    @IBOutlet var taskNameTextField: UITextField!
    @IBOutlet var taskDeleteButton: UIButton!
    
    @IBAction func taskDoneButtonTouched(_ sender: Any) {
        delegate?.taskDoneButtonTouched(cell: self)
    }
    
    @IBAction func taskNameChanged(_ sender: Any) {
        delegate?.taskNameChanged(cell: self)
    }
    
    @IBAction func taskDeleteButtonTouched(_ sender: Any) {
        delegate?.taskDeleteButtonTouched(cell: self)
    }
}
