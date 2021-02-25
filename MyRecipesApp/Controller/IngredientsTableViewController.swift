//
//  IngredientsTableViewController.swift
//  MyRecipesApp
//
//  Created by arta.zidele on 22/02/2021.
//

import UIKit
import CoreData

class IngredientsTableViewController: UITableViewController {
    
    var titleString = String()
    var recipeID = Int()
    var ingredientsList = [Ingredient]()
    
    var context: NSManagedObjectContext?

    @IBOutlet weak var ingredientTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleString
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    @IBAction func addNewIngredient(_ sender: Any) {
        addIngredient()
    }
    private func addIngredient() {
        let alertController = UIAlertController(title: "Add New Ingredient", message: "Add New Ingredient and Amount", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter the new ingredient!"
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .no
        }
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter the amount of new ingredient!"
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .no
        }
        let addAction = UIAlertAction(title: "Add", style: .cancel) { (action: UIAlertAction) in
            let textFieldForIngredient = alertController.textFields?.first
            let textFieldForAmount = alertController.textFields?.last
            let entity = NSEntityDescription.entity(forEntityName: "Ingredient", in: self.context!)
            let ingredient = NSManagedObject(entity: entity!, insertInto: self.context)
            ingredient.setValue(textFieldForIngredient?.text, forKey: "title")
            ingredient.setValue(textFieldForAmount?.text, forKey: "amount")
            ingredient.setValue(self.recipeID, forKey: "recipeID")
            self.saveData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
    func loadData() {
        let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %@", argumentArray: [recipeID])
        do {
            let result = try context?.fetch(request)
            ingredientsList = result!
        } catch {
            fatalError(error.localizedDescription)
        }
        ingredientTableView.reloadData()
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
        return ingredientsList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        let recipe = ingredientsList[indexPath.row]
        cell.textLabel?.text = recipe.value(forKey: "title") as? String
        cell.detailTextLabel?.text = recipe.value(forKey: "amount") as? String
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete!", message: "Are You sure You want to delete?", preferredStyle: .alert)            
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in                
                let recipe = self.ingredientsList[indexPath.row]
                self.context?.delete(recipe)
                self.saveData()
                self.loadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
