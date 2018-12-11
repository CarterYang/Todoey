import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    //Let itemArray to be the array of Item objects
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        //"didset" is going to happen as soon as the "selectedCategory" get set with a value
        didSet {
            //Call method to reterive data
            loadItems()
        }
    }
    
    //Path where the data is being stored in current APP
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    //Grab the reference of context inorder to CRUR data from core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    ///////////////////////////////////////////////////////////////////////////
    //MARK: Tableview delegate methods
    ///////////////////////////////////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Checkmark manipulation
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        itemArray[indexPath.row].setValue(!itemArray[indexPath.row].done, forKey: "done")
        
        //Delete from database
        //Order matters! First delete in database then in array!
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        //Call method to save data
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
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
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            //Call method to save data
            self.saveItems()
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

    //Conmmit context to save in persistentContainer, by calling "context.save()"
    func saveItems() {
        
        do {
            try context.save()
        }
        catch {
            print("Error saving context \(error)")
        }
        
        //Refresh the tableview by calling the Tableview datasource methods again to reload the data
        self.tableView.reloadData()
    }
    
    //Retrieve the data from database
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        //Query the data to find the correspond result from parentCategory
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //If the argument "predicate" is not nil
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        //If the argument "predicate" is nil
        else {
            request.predicate = categoryPredicate
        }
        
        //Do the fetch request and save the result to the "itemArray"
        do {
            //If fetch successed, save the result to "itemArray"
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
}

///////////////////////////////////////////////////////////////////////////
//MARK: search bar methods
///////////////////////////////////////////////////////////////////////////
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //Structure the query. ([cd] refers to "not case and diacritic sensitive")
        //Add the query to the request
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //Sort the result from the database in the order of our choice
        //Add the sort to the query
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        //Call function "LoadItem" with external parameter
        loadItems(with: request, predicate: predicate)
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

