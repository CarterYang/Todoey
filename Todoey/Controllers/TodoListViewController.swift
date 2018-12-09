import UIKit

class TodoListViewController: UITableViewController {

    //Let itemArray to be the array of Item objects
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    //TODO: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //Retrieve the data from UserDefault, show the updated array
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
    }

    //TODO: Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Check the done property of object and display check mark
        //Use Ternary Operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //TODO: Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print (itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
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

