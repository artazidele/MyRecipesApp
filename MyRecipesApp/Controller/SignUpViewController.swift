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
    }
    private func warningPopUp(withTitle title: String?, withMessage message: String?) {
        DispatchQueue.main.async {
            let popUp = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            popUp.addAction(okButton)
            self.present(popUp, animated: true)
        }
    }
    private func signUp(){
        let userName = usernameField.text!
        let password = passwordFirstField.text!
        let userID = usersList.count + 1
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", argumentArray: [userName])
        var exist = false
        do {
            let result = try context?.fetch(request)
            usersList = result!
            if result != nil {
                exist = true
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        
        if password != passwordSecondField.text {
            self.warningPopUp(withTitle: "Passwords do not match!", withMessage: "You have to write one password in both fields!")
        } else if exist == true {
            warningPopUp(withTitle: "Username exists!", withMessage: "You have to choose other username!")
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "User", in: self.context!)
            let recipe = NSManagedObject(entity: entity!, insertInto: self.context)
            recipe.setValue(userName, forKey: "username")
            recipe.setValue(password, forKey: "password")
            recipe.setValue(userID, forKey: "userID")
            self.saveData()
            toLogIn()
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
