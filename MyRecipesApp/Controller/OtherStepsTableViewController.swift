//
//  OtherStepsTableViewController.swift
//  MyRecipesApp
//
//  Created by arta.zidele on 24/02/2021.
//

import UIKit
import CoreData

class OtherStepsTableViewController: UITableViewController {
    
    var titleString = String()
    var recipeID = Int()
    var stepsList = [Step]()
    
    var context: NSManagedObjectContext?

    @IBOutlet weak var stepTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "\(titleString)"
        self.title = "\(recipeID)"
        stepTableView.delegate = self
        stepTableView.dataSource = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
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
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stepsList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "otherStepCell", for: indexPath)
        let recipe = stepsList[indexPath.row]
        cell.textLabel?.text = recipe.value(forKey: "stepDescription") as? String
        return cell
    }
}

