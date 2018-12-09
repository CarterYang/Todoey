import UIKit

class TodoListViewController: UITableViewController {

    //Let itemArray to be the array of Item objects
    var itemArray = [Item]()
    
    //Create a file path to the document folder
    //Use appendingPathComponent to create unique P list file path to store the data
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // TODO: View did load
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        //Call method to reterive data
        loadItems()
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //TODO: Tableview datasource methods
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //TODO: Tableview delegate methods
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print (itemArray[indexPath.row])
        
        //Checkmark manipulation
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //Call method to save data
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // TODO: add new items
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
            
            //Call method to save data
            self.saveItems()
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
  
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // TODO: Model manipulation methods
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //Part 1: Encoding data with NSCoder
    //Save updated itemArray to the p list we create before
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error encoding item array, \(error)")
        }
        
        //Refresh the tableview by calling the Tableview datasource methods again to reload the data
        self.tableView.reloadData()
    }
    
    //Part 2: Decoding data with NSCoder
    //Retrieve the data from UserDefault, show the updated array
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}

