import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    
    //Grab the reference of context inorder to CRUR data from core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexpath: IndexPath) -> UITableViewCell {
        
        //Create a reusable cell for table
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexpath)
        
        //Create the item inside each cell
        let item = categories[indexpath.row]
        cell.textLabel?.text = item.name
        
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
            destinationVC.selectedCategory = categories[indexPath.row]
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
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            
            //Call save function to save the created category
            self.saveCategories()
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
    
    //Conmmit context to save in persistentContainer, by calling "context.save()"
    func saveCategories() {
        
        do {
            try context.save()
        }
        catch {
            print("Error saving category \(error)")
        }
        
        //Refresh the tableview by calling the Tableview datasource methods again to reload the data
        self.tableView.reloadData()
    }
    
    //Retrieve the data from database
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        //Do the fetch request and save the result to the "itemArray"
        do {
            //If fetch successed, save the result to "categories"
            categories = try context.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
}
