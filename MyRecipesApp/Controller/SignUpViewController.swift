//
//  SignUpViewController.swift
//  MyRecipesApp
//
//  Created by arta.zidele on 23/02/2021.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController {

    var usersList = [User]()
    var context: NSManagedObjectContext?
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordFirstField: UITextField!
    @IBOutlet weak var passwordSecondField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign Up"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        signUp()
        toLogIn()
    }
    private func signUp(){
        let userName = usernameField.text
        let password = passwordFirstField.text
        let userID = usersList.count + 1
        if password != passwordSecondField.text {

            
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "User", in: self.context!)
            let recipe = NSManagedObject(entity: entity!, insertInto: self.context)
            recipe.setValue(userName, forKey: "username")
            recipe.setValue(password, forKey: "password")
            recipe.setValue(userID, forKey: "userID")
            self.saveData()
        }
    }
    func saveData() {
        do {
            try self.context?.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    // MARK: - Navigation
    private func toLogIn() {
        navigationController?.popToRootViewController(animated: true)
    }
}
