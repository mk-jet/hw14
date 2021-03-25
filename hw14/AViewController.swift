import UIKit

class Human {
    static let shared = Human()
    
    private let kFirstNameKey = "Human.kFirstNameKey"
    private let kLastNameKey = "Human.kLastNameKey"
    
    var firstName: String? {
        set { UserDefaults.standard.set(newValue, forKey: kFirstNameKey) }
        get { return UserDefaults.standard.string(forKey: kFirstNameKey) }
    }
    var lastName: String? {
        set { UserDefaults.standard.set(newValue, forKey: kLastNameKey) }
        get { return UserDefaults.standard.string(forKey: kLastNameKey) }
    }
}

class AViewController: UIViewController {
    @IBOutlet var firstNameTextfield: UITextField!
    @IBOutlet var lastNameTextfield: UITextField!
    
    @IBAction func firstNameChanged(_ sender: Any) { Human.shared.firstName = firstNameTextfield.text }
    @IBAction func lastNameChanged(_ sender: Any) { Human.shared.lastName = lastNameTextfield.text }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextfield.text = Human.shared.firstName != nil ? Human.shared.firstName : "Input first name here"
        lastNameTextfield.text = Human.shared.lastName != nil ? Human.shared.lastName : "Input last name here"
    }
}
