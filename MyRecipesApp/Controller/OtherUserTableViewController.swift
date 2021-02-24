//
//  OtherUserTableViewController.swift
//  MyRecipesApp
//
//  Created by arta.zidele on 23/02/2021.
//

import UIKit
import CoreData

class OtherUserTableViewController: UITableViewController {
    
    var userID = Int()
    var recipesList = [Recipe]()
    var context: NSManagedObjectContext?
    
    @IBOutlet weak var otherTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otherTableView.delegate = self
        otherTableView.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    @IBAction func findRecipe(_ sender: Any) {
        findWith()
    }
    @IBAction func seeAllRecipes(_ sender: Any) {
        allData()
    }
    private func allData(){
        loadData()
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
        request.predicate = NSPredicate(format: "title CONTAINS %@ && userID != %@", argumentArray: [withTitle, userID])
        do {
            let result = try context?.fetch(request)
            recipesList = result!
        } catch {
            fatalError(error.localizedDescription)
        }
        otherTableView.reloadData()
    }
    func loadData() {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "userID != %@", argumentArray: [userID])
        do {
            let result = try context?.fetch(request)
            recipesList = result!
        } catch {
            fatalError(error.localizedDescription)
        }
        otherTableView.reloadData()
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipesList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "otherRecipeCell", for: indexPath)
        let recipe = recipesList[indexPath.row]
        cell.textLabel?.text = recipe.value(forKey: "title") as? String
        return cell
    }
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "OtherRecipeView") as? OtherOneViewController else { return }
        
        vc.titleString = recipesList[indexPath.row].title ?? ""
        vc.recipeID = Int(recipesList[indexPath.row].recipeID)
        
            
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
