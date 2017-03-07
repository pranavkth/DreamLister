//
//  ViewController.swift
//  DreamLister
//
//  Created by pranav gupta on 29/01/17.
//  Copyright © 2017 Pranav gupta. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    // creating a FRC and telling the entity which we will be working with.
    
    var controller : NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        //generateTestData()
        attemptFetch()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // below line returns a reusable cell of tableview with the identifier as itemcell.
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
        
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath){
        // once the fetch is successfull the controller will fetch sections which inturn will contain rows which are of the type nsmanaged objects.
        
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
        
    }
    
    // this function is called when a row of table view is clicked on 
    // here it takes us to another screen where we can edit/delete it.
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = controller.fetchedObjects , objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC"{
            
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
    }
}
    
    // this function is used to update the contents of the table view cell with the fetched cell.
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // it checks if there are any sections in table view, then takes the data of a particular section and places it in sectioninfo. since data is in the form of nsmanaged objects it sectioninfo.numberofojects returns the count of number of rows in section.
        
        if let sections = controller.sections{
            let sectioninfo = sections[section]
            return sectioninfo.numberOfObjects
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections{
            return sections.count
        }
        return 0
    }
    
    // returns the height of the rows of the tableview.
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    // function called when segment value is changed.
    
    
    @IBAction func segmentChange(_ sender: Any) {
        
        attemptFetch()
        tableview.reloadData()
    }
    
    
    // function to attempt fetch of the data from the database.
    
    func attemptFetch(){
        
        let fetchRequest : NSFetchRequest<Item> = Item.fetchRequest()
        let datesort = NSSortDescriptor(key: "created", ascending: true)
        let pricesort = NSSortDescriptor(key: "price", ascending: true)
        let titlesort = NSSortDescriptor(key:"title",ascending:true)
        
        if segment.selectedSegmentIndex == 0{
            fetchRequest.sortDescriptors = [datesort]
        }
        else if segment.selectedSegmentIndex == 1{
            fetchRequest.sortDescriptors = [pricesort]
        }
        else if segment.selectedSegmentIndex == 2{
            fetchRequest.sortDescriptors = [titlesort]
        }
                // code to create a controller.
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        // part of boilerplatecode and will make the functions to listen to this class.
        
        controller.delegate = self
        self.controller = controller
        
        do {
            try controller.performFetch()
        }
        catch{
            let error = error as NSError
            print("\(error)")
            
        }
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.endUpdates()
    }
    
    
    
    // when we will make change i.e insertion updation deletion move.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type){
        case.insert:
            if let indexPath = newIndexPath {
                tableview.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableview.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath{
                let cell = tableview.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableview.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let indexPath = newIndexPath {
                tableview.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    func generateTestData(){
        
        let item = Item(context: context)
        item.title = "New MacbookPro"
        item.price = 1800.00
        item.details = "My dream computer.Cant wait till september to purchase this one"
        
        let item2 = Item(context: context)
        item2.title = "Beats headphones"
        item2.price = 500
        item2.details = "My dream headphones.Can't wait till september to purchase this one"

        ad.saveContext()
    }

}

