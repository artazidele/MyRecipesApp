//
//  LogInViewController.swift
//  MyRecipesApp
//
//  Created by arta.zidele on 23/02/2021.
//

import UIKit
import CoreData

class LogInViewController: UIViewController {

    var user = [User]()
    var context: NSManagedObjectContext?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        checkUser()
    }
    private func warningPopUp(withTitle title: String?, withMessage message: String?) {
        DispatchQueue.main.async {
            let popUp = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            popUp.addAction(okButton)
            self.present(popUp, animated: true)
        }
    }
    private func checkUser() {
        var userId = Int16()
        let username = usernameTextField.text!
        let password = passwordTextField.text
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", argumentArray: ["\(username)"])
        do {
            let result = try context?.fetch(request)
            user = result!
            if user.count == 1 {
                userId = user[0].userID
                print(userId)
                let requestPassword = user[0].password
                if password == requestPassword && username != "" {
                    toUserView(userID: Int(userId))
                } else {
                    self.warningPopUp(withTitle: "The password is not correct!", withMessage: "You have to write correct password!")
                    passwordTextField.text = ""
                }
            } else {
                self.warningPopUp(withTitle: "There is an error in username!", withMessage: "You have to write correct username!")
                usernameTextField.text = ""
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - Navigation
    private func toUserView(userID: Int){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "UserView") as? UserViewController else { return }
        vc.usernameString = usernameTextField.text ?? ""
        vc.userID = userID
        navigationController?.pushViewController(vc, animated: true)
        usernameTextField.text = ""
        passwordTextField.text = ""
    }


}
