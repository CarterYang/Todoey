import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    //Let todoItems to be the array of Item objects
    var todoItems: Results<Item>?
    
    //Initialize new realm
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        //"didset" is going to happen as soon as the "selectedCategory" get set with a value
        didSet {
            //Call method to reterive data
            loadItems()
        }
    }
    
    //Path where the data is being stored in current APP
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    
    ///////////////////////////////////////////////////////////////////////////
    // MARK: View did load
    ///////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
    }

    ///////////////////////////////////////////////////////////////////////////
    // MARK: Tableview datasource methods
    ///////////////////////////////////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    ///////////////////////////////////////////////////////////////////////////
    //MARK: Tableview delegate methods
    ///////////////////////////////////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    //Delete item in database
                    //realm.delete(item)
                    item.done = !item.done
                }
            }
            catch {
                print("Error saving done status, \(error)")
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // MARK: add new items
    ///////////////////////////////////////////////////////////////////////////
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //Set up new alert
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen once the user clicks the add item button on UIAlert
            //Because selectedCategory is an optional category, have to unwrap it by using option binding
            //And save data to realm
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                    print("Error saving category \(error)")
                }
            }

            //Refresh the tableview by calling the Tableview datasource methods again to reload the data
            self.tableView.reloadData()
        }

        //Add text field in alert
        alert.addTextField { (alertTextField) in
            //Setup text field
            textField = alertTextField
            alertTextField.placeholder = "Create new item"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
  
    ///////////////////////////////////////////////////////////////////////////
    // MARK: Model manipulation methods
    ///////////////////////////////////////////////////////////////////////////
    
    //Retrieve the data from database
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
}

///////////////////////////////////////////////////////////////////////////
//MARK: search bar methods
///////////////////////////////////////////////////////////////////////////
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Query the result and sort the result by "title"
        //todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        //Go back to the original list when cancel the search
        if searchBar.text?.count == 0 {
            loadItems()

            //Dismiss the cusor and keyboard, means asked to relinquish its status as first responder in its windows
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }

    }
}

