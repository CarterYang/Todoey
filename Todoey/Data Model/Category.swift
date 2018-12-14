import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    
    //Forward relationship: inside each category, there is a "items" going to point to a List of "Item" object
    let items = List<Item>()
}
