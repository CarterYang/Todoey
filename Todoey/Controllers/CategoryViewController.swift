import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    //Initialize new realm
    let realm = try! Realm()
    
    //Set as the collection of result of Category object
    var categories: Results<Category>?
    
    ///////////////////////////////////////////////////////////////////////////
    // MARK: View did load
    ///////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    ///////////////////////////////////////////////////////////////////////////
    // MARK: Tableview datasource methods
    ///////////////////////////////////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //If not nil return "count", if nil return 1; same as set a default value to it.
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexpath: IndexPath) -> UITableViewCell {
        
        //Create a reusable cell for table
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexpath)
        
        //Create the item inside each cell
        cell.textLabel?.text = categories?[indexpath.row].name ?? "Not Category Added Yet"
        
        return cell
    }
    
    ///////////////////////////////////////////////////////////////////////////
    //MARK: Tableview delegate methods
    ///////////////////////////////////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //The work just before performing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        //Grab the category that correspond to the selected cell
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // MARK: add new items
    ///////////////////////////////////////////////////////////////////////////
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //Create new alert and set up the new alert
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //What will happen once the user clicks the add item button on UIAlert
            let newCategory = Category()
            newCategory.name = textField.text!
            
            //Call save function to save the created category
            self.save(category: newCategory)
        }
        
        //Add textfield in the alert
        alert.addTextField { (field) in
            //Set up textfield
            textField = field
            field.placeholder = "Create new category"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // MARK: Model manipulation methods
    ///////////////////////////////////////////////////////////////////////////
    
    //Save date to realm
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving category \(error)")
        }
        
        //Refresh the tableview by calling the Tableview datasource methods again to reload the data
        self.tableView.reloadData()
    }
    
    //Retrieve the data from database
    func loadCategories() {
        
        //Fetch all the items inside realm of Category object
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
}
