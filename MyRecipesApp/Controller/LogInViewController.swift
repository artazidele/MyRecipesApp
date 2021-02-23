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
    private func checkUser() {
        var userId = Int16()
        let username = usernameTextField.text!
        let password = passwordTextField.text
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", argumentArray: ["\(username)"])
        do {
            let result = try context?.fetch(request)
            user = result!
            userId = user[0].userID
            print(userId)
            let requestPassword = user[0].password
            if password == requestPassword {
                toUserView(userID: Int(userId))
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
    }


}
