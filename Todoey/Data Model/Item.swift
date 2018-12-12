import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    //Reverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
