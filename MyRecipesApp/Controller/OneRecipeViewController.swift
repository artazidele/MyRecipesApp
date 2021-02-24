//
//  OneRecipeViewController.swift
//  MyRecipesApp
//
//  Created by arta.zidele on 22/02/2021.
//

import UIKit
import CoreData

class OneRecipeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    var titleString = String()
    var recipeID = Int()
    var context: NSManagedObjectContext?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleString
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func editRecipeTitle(_ sender: Any) {
        editTitle()
    }
    private func editTitle() {
        
        
        let alertController = UIAlertController(title: "Edit Title", message: "Edit Title", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter the new title of recipe!"
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .no
        }
        var recipeToEdit = [Recipe]()
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %@", argumentArray: [recipeID])
        do {
            let result = try context?.fetch(request)
            recipeToEdit = result!
        } catch {
            fatalError(error.localizedDescription)
        }
        let addAction = UIAlertAction(title: "Save", style: .cancel) { (action: UIAlertAction) in
            let textFieldForTitle = alertController.textFields?.first
            let recipe = recipeToEdit[0]
            recipe.setValue(textFieldForTitle?.text, forKey: "title")
            self.saveData()
            self.titleLabel.text = textFieldForTitle?.text
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
    func saveData() {
        do {
            try self.context?.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    // MARK: - Navigation
    @IBAction func seeIngredients(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "IngredientsView") as? IngredientsTableViewController else { return }
        
        vc.titleString = titleLabel.text ?? ""
        vc.recipeID = recipeID
            
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func seeSteps(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "StepsView") as? StepsTableViewController else { return }
        
        vc.titleString = titleLabel.text ?? ""
        vc.recipeID = recipeID
        
            
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
