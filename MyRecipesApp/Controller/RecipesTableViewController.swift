//
//  RecipesTableViewController.swift
//  MyRecipesApp
//
//  Created by arta.zidele on 22/02/2021.
//

import UIKit
import CoreData

class RecipesTableViewController: UITableViewController {
    
    var recipesList = [Recipe]()
    var context: NSManagedObjectContext?

    @IBOutlet weak var recipeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }

    @IBAction func addNewRecipe(_ sender: Any) {
        addRecipe()
    }
    
    private func addRecipe() {
        let alertController = UIAlertController(title: "Add New Recipe", message: "Recipe title", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter the title of new recipe!"
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .no
        }
        let addAction = UIAlertAction(title: "Add", style: .cancel) { (action: UIAlertAction) in
            let textFieldForTitle = alertController.textFields?.first
            let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: self.context!)
            let item = NSManagedObject(entity: entity!, insertInto: self.context)
            item.setValue(textFieldForTitle?.text, forKey: "title")
            self.saveData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
    func loadData() {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            let result = try context?.fetch(request)
            recipesList = result!
        } catch {
            fatalError(error.localizedDescription)
        }
        recipeTableView.reloadData()
    }
    func saveData() {
        do {
            try self.context?.save()
        } catch {
            fatalError(error.localizedDescription)
        }
        loadData()
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipesList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        let recipe = recipesList[indexPath.row]
        cell.textLabel?.text = recipe.value(forKey: "title") as? String
        return cell
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete!", message: "Are You sure You want to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
                
                let item = self.recipesList[indexPath.row]
                
                self.context?.delete(item)
                self.saveData()
                self.loadData()
                
            }))
            self.present(alert, animated: true)
        }    
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "RecipeView") as? OneRecipeViewController else { return }
        
        vc.titleString = recipesList[indexPath.row].title ?? ""
        vc.recipeID = indexPath.row
        
            
        navigationController?.pushViewController(vc, animated: true)
        
    }

}



