//
//  UserViewController.swift
//  MyRecipesApp
//
//  Created by arta.zidele on 23/02/2021.
//

import UIKit
import CoreData

class UserViewController: UIViewController {

    @IBOutlet weak var helloLabel: UILabel!
    var userID = Int()
    var usernameString = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        helloLabel.text = "Hello, \(usernameString)! Your ID is \(userID)."

        // Do any additional setup after loading the view.
    }
    @IBAction func otherRecipesTapped(_ sender: Any) {
        toOtherRecipes()
    }
    @IBAction func myRecipesTapped(_ sender: Any) {
        toMyRecipes()
    }
    // MARK: - Navigation
    private func toMyRecipes(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "MyRecipes") as? RecipesTableViewController else { return }
        vc.userID = userID
        navigationController?.pushViewController(vc, animated: true)
    }
    private func toOtherRecipes(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "OtherRecipes") as? OtherUserTableViewController else { return }
        vc.userID = userID
        navigationController?.pushViewController(vc, animated: true)
    }
}
