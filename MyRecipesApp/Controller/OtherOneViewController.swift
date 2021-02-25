//
//  OtherOneViewController.swift
//  MyRecipesApp
//
//  Created by arta.zidele on 24/02/2021.
//

import UIKit
import CoreData

class OtherOneViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    var titleString = String()
    var usernameList = [User]()
    var recipeList = [Recipe]()
    var recipeID = Int()
    var userID = Int()
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        let titleStringSecond = self.getUsername(recipeId: self.recipeID)
        titleLabel.text = titleString + " made by " + titleStringSecond
    }
    func getUsername(recipeId: Int) -> String {
            let request: NSFetchRequest<User> = User.fetchRequest()
            request.predicate = NSPredicate(format: "userID == %@", argumentArray: ["\(userID)"])
            do {
                let result = try context?.fetch(request)
                usernameList = result!
                let titleSecond = String(usernameList[0].username!)
                return titleSecond
            } catch {
                fatalError(error.localizedDescription)
            }
    }
    @IBAction func seeIngredientsTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "OtherIngredients") as? OtherIngredientsTableViewController else { return }
        
        vc.titleString = titleLabel.text ?? ""
        vc.recipeID = recipeID
            
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func seeStepsTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "OtherSteps") as? OtherStepsTableViewController else { return }
        
        vc.titleString = titleLabel.text ?? ""
        vc.recipeID = recipeID
        
            
        navigationController?.pushViewController(vc, animated: true)
    }
}
