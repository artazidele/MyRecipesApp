//
//  OtherIngredientsTableViewController.swift
//  MyRecipesApp
//
//  Created by arta.zidele on 24/02/2021.
//

import UIKit
import CoreData

class OtherIngredientsTableViewController: UITableViewController {
    
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
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ingredientsList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "otherIngredientCell", for: indexPath)
        let recipe = ingredientsList[indexPath.row]
        cell.textLabel?.text = recipe.value(forKey: "title") as? String
        cell.detailTextLabel?.text = recipe.value(forKey: "amount") as? String
        return cell
    }
}
