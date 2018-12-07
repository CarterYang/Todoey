import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Ivy", "Buy Egg", "Destory Demo"]
    
    let defaults = UserDefaults.standard
    
    //TODO: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Retrieve the data from UserDefault, show the updated array
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
        
    }

    //TODO: Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //TODO: Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print (itemArray[indexPath.row])
        
        //Add checkmark when selected
        //Remove checkmark when it already selected
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            //self.itemArray.append(textField.text ?? defaultItem)
            self.itemArray.append(textField.text!)
            
            //Save updated itemArray to UserDefault, "key" is the identifier this array in UserDefaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //Refresh the table view
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

