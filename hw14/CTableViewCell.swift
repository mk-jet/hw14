import UIKit

protocol CTableViewCellDelegate: Any {
    func taskDoneButtonTouhced (cell: CTableViewCell)
    func taskNameChanged (cell: CTableViewCell)
    func taskDeleteButtonTouched (cell: CTableViewCell)
}

class CTableViewCell: UITableViewCell {
    var delegate: CTableViewCellDelegate?

    @IBOutlet var taskDoneButton: UIButton!
    @IBOutlet var taskNameTextField: UITextField!
    @IBOutlet var taskDeleteButton: UIButton!
    
    @IBAction func taskDoneButtonTouhced(_ sender: Any) {
        delegate?.taskDoneButtonTouhced(cell: self)
    }
    
    @IBAction func taskNameChanged(_ sender: Any) {
        delegate?.taskNameChanged(cell: self)
    }
    
    @IBAction func taskDeleteButtonTouched(_ sender: Any) {
        delegate?.taskDeleteButtonTouched(cell: self)
    }
}
