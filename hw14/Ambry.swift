import Foundation
import RealmSwift

class Task: Object{
    @objc dynamic var taskName = ""
    @objc dynamic var taskDone = false
}


class Ambry {
    static let shared = Ambry()
    let tasks = try! Realm()
}
