//
//  SalesViewController.swift
//  GoldAward
//
//  Created by Wendy Barnes on 11/17/18.
//  Copyright © 2018 Wendy Barnes. All rights reserved.
//

import UIKit
import CoreData

class SalesViewController: UIViewController {

    @IBOutlet weak var saTable: UITableView!
    
    var sales: [NSManagedObject] = []
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Sale",
                                      message: "Add a new sale",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
            [unowned self] action in
                                        
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
                    
            }
                                        
            self.save(name: nameToSave)
            self.saTable.reloadData()
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
                
        let managedContext =
            appDelegate.persistentContainer.viewContext
                
        let entity =
            NSEntityDescription.entity(forEntityName: "SalesList",
                                        in: managedContext)!
                
        let saleslist = NSManagedObject(entity: entity,
                                        insertInto: managedContext)
        
        saleslist.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            sales.append(saleslist)
            }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saTable.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "SalesList")
        
        do {
            sales = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
}

// MARK: - UITableViewDataSource
extension SalesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let theSale = sales[indexPath.row]
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell",
                                          for: indexPath)
        cell.textLabel?.text = theSale.value(forKeyPath: "name") as? String
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sales.count
        
    }
}
