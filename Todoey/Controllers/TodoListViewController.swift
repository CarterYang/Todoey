import UIKit

class TodoListViewController: UITableViewController {

    //Let itemArray to be the array of Item objects
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    //TODO: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Retrieve the data from UserDefault, show the updated array
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemArray = items
//        }
        
        //Create new object
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Egg"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destory Demo"
        itemArray.append(newItem3)
        
    }

    //TODO: Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
                
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        //Check the done property of object and display check mark
        if itemArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    //TODO: Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print (itemArray[indexPath.row])
        
        if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
        }
        else {
            itemArray[indexPath.row].done = false
        }
        
        //Refresh the tableview by calling the Tableview datasource methods again to reload the data inorder to show the checkmark
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //TODO: add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        //let defaultItem : String = "New Item"
        
        //Pop up new alert
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen once the user clicks the add item button on UIAlert
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            //Save updated itemArray to UserDefault, "key" is the identifier this array in UserDefaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //Refresh the tableview by calling the Tableview datasource methods again to reload the data inorder to show the added new item
            self.tableView.reloadData()
        }

        //Add text field in alert
        alert.addTextField { (alertTextField) in
            //Setup text field
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

