//
//  RecipesTableViewController.swift
//  MyRecipesApp
//
//  Created by arta.zidele on 22/02/2021.
//

import UIKit
import CoreData

class RecipesTableViewController: UITableViewController {
    
    var userID = Int()
    var recipesList = [Recipe]()
    var allRecipesList = [Recipe]()
    var context: NSManagedObjectContext?

    @IBOutlet weak var recipeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Recipes"
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
    
    @IBAction func findRecipeWith(_ sender: Any) {
        findWith()
    }
    
    @IBAction func seeAllData(_ sender: Any) {
        allData()
    }
    private func allData(){
        loadData()
    }
    private func addRecipe() {
        let alertController = UIAlertController(title: "Add New Recipe", message: "Add New Recipe", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter the title of new recipe!"
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .no
        }
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            let result = try context?.fetch(request)
            allRecipesList = result!
        } catch {
            fatalError(error.localizedDescription)
        }
        let recipeCount = allRecipesList.count
        let recipeID = (allRecipesList[recipeCount - 1].recipeID) + 1
        let addAction = UIAlertAction(title: "Add", style: .cancel) { (action: UIAlertAction) in
            let textFieldForTitle = alertController.textFields?.first
            let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: self.context!)
            let recipe = NSManagedObject(entity: entity!, insertInto: self.context)
            recipe.setValue(textFieldForTitle?.text, forKey: "title")
            recipe.setValue(self.userID, forKey: "userID")
            recipe.setValue(recipeID, forKey: "recipeID")
            self.saveData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
    private func findWith(){
        let alertController = UIAlertController(title: "Find Recipe", message: "Find Recipe", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter recipe!"
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
        }
        let findAction = UIAlertAction(title: "Find", style: .cancel) { (action: UIAlertAction) in
            let textFieldForIngredient = alertController.textFields?.first
            let titleToFind = textFieldForIngredient?.text
            self.findData(withTitle: titleToFind ?? "")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(findAction)
        present(alertController, animated: true)
    }
    func findData(withTitle: String) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS %@ && userID == %@", argumentArray: [withTitle, userID])
        do {
            let result = try context?.fetch(request)
            recipesList = result!
        } catch {
            fatalError(error.localizedDescription)
        }
        recipeTableView.reloadData()
    }
    func loadData() {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "userID == %@", argumentArray: [userID])
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete!", message: "Are You sure You want to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
                let recipe = self.recipesList[indexPath.row]
                let recipeID = Int(self.recipesList[indexPath.row].recipeID)
                let request: NSFetchRequest<Step> = Step.fetchRequest()
                request.predicate = NSPredicate(format: "recipeID == %@", argumentArray: [recipeID])
                do {
                    let result = try self.context?.fetch(request)
                    let stepsList = result!
                    for step in stepsList {
                        self.context?.delete(step)
                        self.saveData()
                    }
                } catch {
                    fatalError(error.localizedDescription)
                }
                let requestI: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
                requestI.predicate = NSPredicate(format: "recipeID == %@", argumentArray: [recipeID])
                do {
                    let resultI = try self.context?.fetch(requestI)
                    let ingredientsList = resultI!
                    for ingredient in ingredientsList {
                        self.context?.delete(ingredient)
                        self.saveData()
                    }
                } catch {
                    fatalError(error.localizedDescription)
                }
                self.context?.delete(recipe)
                self.saveData()
                self.loadData()
                
            }))
            self.present(alert, animated: true)
        }    
    }
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "RecipeView") as? OneRecipeViewController else { return }
        vc.titleString = recipesList[indexPath.row].title ?? ""
        vc.recipeID = Int(recipesList[indexPath.row].recipeID)
        
            
        navigationController?.pushViewController(vc, animated: true)
        
    }

}



