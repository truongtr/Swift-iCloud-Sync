//
//  ViewController.swift
//  ermiasTableView
//
//  Created by Truc Truong on 27/04/15.
//  Copyright (c) 2015 Truc Truong. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class ErmiasTableViewController: UITableViewController,UITableViewDataSource, UITableViewDelegate, EntryDelegate,NSFetchedResultsControllerDelegate {
    
    //@IBOutlet var tableView: UITableView!
    
    //var Ermias = ["Fun", "Handsome", "Cool", "Noway"]
    // AppDelegate
    
    var managedObjectContext:  NSManagedObjectContext? = nil
    var isDeletedAction:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "contextDidSave:",
            name: NSManagedObjectContextDidSaveNotification,
            object: self.fetchedResultsController.managedObjectContext)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "contextDidChange:",
            name: NSManagedObjectContextObjectsDidChangeNotification,
            object: self.fetchedResultsController.managedObjectContext)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func contextDidSave(notification: NSNotification){
        
        
        
    }
    func contextDidChange(notification: NSNotification){
        
        println("Content Did change")
        let sender = notification.object as! NSManagedObjectContext
        println(sender)
        if(!isDeletedAction){
           //c self.fetchedResultsController.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
        }else{
            isDeletedAction = false
        }
        
        if sender != self.fetchedResultsController.managedObjectContext{
            println("Save Detected Outside Thread Main")
            
        }
    }
    
    
    
    func userDidFinish(controller: NewEntryViewController, entry:String){
        
        let context = self.fetchedResultsController.managedObjectContext
        let entity = self.fetchedResultsController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context) as! NSManagedObject
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        newManagedObject.setValue(entry, forKey: "text")
        newManagedObject.setValue(NSDate(), forKey: "date")
        
        // Save the context.
        var error: NSError? = nil
        if !context.save(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        controller.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Create a new cell at each index path
         let cell = tableView.dequeueReusableCellWithIdentifier("Detail", forIndexPath: indexPath) as! UITableViewCell
       
        // cell.textLabel?.text = Ermias[indexPath.row]
        self.configureCell(cell, atIndexPath: indexPath)
        
        return cell
        
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ){
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
            var error: NSError? = nil
            if !context.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                println("Unresolved error \(error), \(error!.userInfo)")
                println("Co loi xay ra")
                abort()
            }
            isDeletedAction = true
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "shit"){
            
            let nextViewController = segue.destinationViewController as! DetailViewController
            let index = tableView.indexPathForSelectedRow()
            var temp = String()
            let object = self.fetchedResultsController.objectAtIndexPath(index!) as! NSManagedObject
            // cell.textLabel!.text = object.valueForKey("text") as? String

            temp += (object.valueForKey("text") as? String)!
            nextViewController.myText =  temp
            
        }
        if(segue.identifier == "NewEntry"){
            
            let v = segue.destinationViewController as! NewEntryViewController
            
            v.delegate =  self
            
        }
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if(self.fetchedResultsController.fetchedObjects?.count > indexPath.row){
            let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
            cell.textLabel!.text = object.valueForKey("text") as? String
        }
       
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Post", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Left)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Right)
        case .Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Left)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Right)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

}

