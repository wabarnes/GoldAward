//
//  MainTabBarController.swift
//  GoldAward
//
//  Created by Wendy Barnes on 10/13/18.
//  Copyright © 2018 Wendy Barnes. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class MainTabBarViewController: UITabBarController {

    override func viewDidAppear(_ animated: Bool) {                                         // Function runs when app is loaded
        
        super.viewDidAppear(animated)
        NSLog("MainTabBarController:viewDidAppear: Executed")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Prefrences")
        
        do {                                                                                // When function runs does-
            let results: NSArray = try managedContext.fetch(fetchRequest) as NSArray
            if (results.count > 0)  {                                                       // If there are alreay prefrences set it to what prefrences previously was
                let prefrences: NSManagedObject = results[0] as! NSManagedObject
                self.selectedIndex = prefrences.value(forKey: "lastScreen") as? Int ?? 0
                NSLog("selectedIndex is set to: %i",self.selectedIndex)                     // prints the value of int variable
            }
            else  {                                                                         // If there is not a prefrence then set it to zero
                self.selectedIndex = 0
            }
            
        } catch let error as NSError {                                                      // Catches errors
            NSLog("Could not fetch. \(error), \(error.userInfo)")
        }
        
        NotificationCenter.default.addObserver(                                             //Adds an observer
            self,
            selector: #selector(onBackground(_:)),
            name: NSNotification.Name.UIApplicationWillResignActive,
            object: nil)
 
    }

    @objc func onBackground(_ notification:Notification) {                                  // Function runs when app is closed
    NSLog("onBackground")
    
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
        }
    
        let managedContext = appDelegate.persistentContainer.viewContext
    
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Prefrences")
    
        do {                                                                                // When function runs does-
            let results: NSArray = try managedContext.fetch(fetchRequest) as NSArray
            if (results.count > 0)  {                                                       // If there are alreay prefrences then set it to what prefrences previously were
                let prefrences: NSManagedObject = results[0] as! NSManagedObject
                prefrences.setValue(self.selectedIndex, forKey: "lastScreen")
                try managedContext.save()                                                   // Saves before entering background
            }
            else  {                                                                         // There are not any prefrences so creates some
                let entity = NSEntityDescription.entity(forEntityName: "Prefrences", in: managedContext)!
                let prefrences = NSManagedObject(entity: entity, insertInto: managedContext)
                prefrences.setValue(self.selectedIndex, forKeyPath: "lastScreen")
                try managedContext.save()                                                   // Saves before entering background
            }
            
        } catch let error as NSError {                                                      // Catches errors
        NSLog("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool)  {
        super.viewWillDisappear(animated)
    }
    
}
