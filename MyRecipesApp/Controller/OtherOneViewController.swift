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
    var recipeID = Int()
    var context: NSManagedObjectContext?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleString
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
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
