//
//  vvvv.swift
//  SaveAny
//
//  Created by mohamed hashem on 11/29/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import RealmSwift

class ShowDataInFolder: UIViewController {
    
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var editItimebar: UIBarButtonItem!
 
    @IBOutlet weak var search: UISearchBar!
    
    var path = 0
    
    let realm = try! Realm()
    var infoArray: Results<ChildFolder>?
    var selectedFolder: Folder? {
        didSet{
            
            load()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = selectedFolder?.Title
        if (infoArray?.isEmpty)! {
            editItimebar.isEnabled = false
        }
        
        // Do any additional setup after loading the view.
    }
    
   
    // MARK: - Load Realm
    func load(){
        
        infoArray = selectedFolder?.childfolder.sorted(byKeyPath: "Title", ascending: true)
      // myTable.reloadData()
        
    }
    
    
    // MARK: - save Realm
    func save(info: ChildFolder) {
        do{
            try  realm.write {
                realm.add(info)
            }
            
        }catch{
            
            print("Error in reading data : \(error)")
        }
      //  myTable.reloadData()
    }
    
    
    // MARK: - Edit cell
    @IBAction func edit(_ sender: Any) {
       myTable.isEditing = !myTable.isEditing
        if myTable.isEditing {
           editItimebar.title  = "Done"
        }else{
            editItimebar.title = "Edit"
        
        }
        
    }
}

// MARK: - Extension
extension ShowDataInFolder : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celll", for: indexPath)
        if infoArray?.isEmpty == false{
            cell.textLabel?.text = infoArray![indexPath.row].Title
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        path = Int(indexPath.row)
        performSegue(withIdentifier: "show2", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if (infoArray?.isEmpty)! {
               editItimebar.isEnabled = false
            }
            if let item = infoArray?[indexPath.row] {
                
                do{
                    try realm.write {
                        realm.delete(item)
                    }
                    
                }catch{
                    print("Error Savinge done status\(error)")
                }
                myTable.reloadData()
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        
    }
    
    //MARK: - navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddListItem"{
            let vcs = segue.destination as! AddListItem
            vcs.selectedChildFolder1 = selectedFolder
           
            vcs.Saving = {
               
                [weak self] in self!.myTable.reloadData()
                if !(self!.infoArray?.isEmpty)! {
                    self!.editItimebar.isEnabled = true
                }
            }
        }else{
            let destinationVC = segue.destination as! FolderInfoViewController
            destinationVC.selectedChildFolder = infoArray?[path]
        }
        
    }
    
    
}

//MARK: - Search function

extension ShowDataInFolder : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        infoArray = infoArray?.filter("Title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "Create_Date", ascending: true)
        self.myTable.reloadData()
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            load()
            myTable.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
}
