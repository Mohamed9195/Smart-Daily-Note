//
//  Trash.swift
//  SaveAny
//
//  Created by mohamed hashem on 11/30/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import RealmSwift

class Trash: UITableViewController {

    
    let realm = try! Realm()
    var DeleteArray: Results<DeletedData>?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
     DeleteArray =  realm.objects(DeletedData.self)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DeleteArray?.count ?? 1
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! trashCell

        cell.label1.text = DeleteArray?[indexPath.row].Name
        cell.label2.text = DeleteArray?[indexPath.row].Delted_Date.description

        return cell
    }
    
   

   
  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                realm.delete(DeleteArray![indexPath.row])
            }
        
        }
        tableView.reloadData()
    }
  

   

}
