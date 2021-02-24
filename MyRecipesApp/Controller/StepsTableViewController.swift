//
//  StepsTableViewController.swift
//  MyRecipesApp
//
//  Created by arta.zidele on 22/02/2021.
//

import UIKit
import CoreData

class StepsTableViewController: UITableViewController {
    
    var titleString = String()
    var recipeID = Int()
    var stepsList = [Step]()
    
    var context: NSManagedObjectContext?

    @IBOutlet weak var stepTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleString
        stepTableView.delegate = self
        stepTableView.dataSource = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    @IBAction func addNewStep(_ sender: Any) {
        addStep()
    }
    private func addStep() {
        let alertController = UIAlertController(title: "Add New Step", message: "Add New Step", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter the new step!"
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .no
        }
        let addAction = UIAlertAction(title: "Add", style: .cancel) { (action: UIAlertAction) in
            let textFieldForStep = alertController.textFields?.first
            let entity = NSEntityDescription.entity(forEntityName: "Step", in: self.context!)
            let step = NSManagedObject(entity: entity!, insertInto: self.context)
            step.setValue(textFieldForStep?.text, forKey: "stepDescription")
            step.setValue(self.recipeID, forKey: "recipeID")
            self.saveData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
    func loadData() {
        let request: NSFetchRequest<Step> = Step.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %@", argumentArray: [recipeID])
        do {
            let result = try context?.fetch(request)
            stepsList = result!
        } catch {
            fatalError(error.localizedDescription)
        }
        stepTableView.reloadData()
    }
    func saveData() {
        do {
            try self.context?.save()
        } catch {
            fatalError(error.localizedDescription)
        }
        loadData()
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stepsList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stepCell", for: indexPath)
        let recipe = stepsList[indexPath.row]
        cell.textLabel?.text = recipe.value(forKey: "stepDescription") as? String
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete!", message: "Are You sure You want to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
                
                let recipe = self.stepsList[indexPath.row]
                
                self.context?.delete(recipe)
                self.saveData()
                self.loadData()
                
            }))
            self.present(alert, animated: true)
        }
    }
}
