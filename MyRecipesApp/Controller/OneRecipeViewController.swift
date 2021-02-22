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

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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