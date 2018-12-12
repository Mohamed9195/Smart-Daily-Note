//
//  FirstViewAdvancedViewController.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/8/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import RealmSwift

class FirstViewAdvancedViewController: UIViewController {
    
    @IBOutlet weak var tableAdvanced: UITableView!
    @IBOutlet weak var editItimebar: UIBarButtonItem!
    
    @IBOutlet weak var search: UISearchBar!
    
    var path = 0
    
    let realm = try! Realm()
    var AdvancedArray: Results<AdvancedModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
      
        if ((AdvancedArray?.isEmpty)!) {
            editItimebar.isEnabled = false
        }
        tableAdvanced.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - Load Realm
    func load(){
        
        AdvancedArray = realm.objects(AdvancedModel.self)
        if AdvancedArray?.isEmpty == false{
            tableAdvanced.reloadData()
        }
        
        
    }
    
    
    // MARK: - save Realm
    func save(Advanced: ChildFolder) {
        do{
            try  realm.write {
                realm.add(Advanced)
            }
            
        }catch{
            
            print("Error in reading data : \(error)")
        }
        //  myTable.reloadData()
    }
    
    
    // MARK: - Edit cell
    @IBAction func edit(_ sender: Any) {
        tableAdvanced.isEditing = !tableAdvanced.isEditing
        if tableAdvanced.isEditing {
            editItimebar.title  = "Done"
             tableAdvanced.allowsSelectionDuringEditing = true
        
        }else{
            editItimebar.title = "Edit"
            
        }
        
    }
    
    
    
}

// MARK: - Extension
extension FirstViewAdvancedViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AdvancedArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellForFirstAdvanced
        
        cell.accessoryType  = (AdvancedArray?[indexPath.row].SubTaskStatusAdvanc)! ?  .checkmark : .none
        cell.lableAdvanced.text = AdvancedArray![indexPath.row].TitleAdvanc
        if AdvancedArray?[indexPath.row].SubTaskStatusAdvanc == true {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (AdvancedArray?[indexPath.row].TitleAdvanc)!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.lableAdvanced.attributedText = attributeString
        }else{
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (AdvancedArray?[indexPath.row].TitleAdvanc)!)
            attributeString.addAttribute(NSAttributedString.Key.accessibilityTextCustom, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.lableAdvanced
                .attributedText = attributeString
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing == true{
            
           
           
            do{
                try realm.write {
                    AdvancedArray?[indexPath.row].SubTaskStatusAdvanc = !(AdvancedArray?[indexPath.row].SubTaskStatusAdvanc)!
                }
                
            }catch{
                print("Error Savinge done status\(error)")
            }
            tableView.deselectRow(at: indexPath, animated: true)
            tableAdvanced.reloadData()
        }else{
            tableView.deselectRow(at: indexPath, animated: true)
            
            path = Int(indexPath.row)
            performSegue(withIdentifier: "toInfoOfadvancedNote" , sender: self)
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if (AdvancedArray?.isEmpty)! {
                editItimebar.isEnabled = false
            }
            if let item = AdvancedArray?[indexPath.row] {
                
                do{
                    try realm.write {
                        realm.delete(item)
                    }
                    
                }catch{
                    print("Error Savinge done status\(error)")
                }
                tableAdvanced.reloadData()
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
        if segue.identifier == "toNewAdvancedNote"{
            let vcs = segue.destination as! AdvancedViewController
            vcs.Saving = {
                
                [weak self] in self!.tableAdvanced.reloadData()
                if !(self!.AdvancedArray?.isEmpty)! {
                    self!.editItimebar.isEnabled = true
                }
            }
        }else{
                        let destinationVC = segue.destination as! InfoOdAdvancedViewController
                        destinationVC.selectedAdvanced = AdvancedArray?[path]
        }
        
    }
    
    
}

//MARK: - Search function

extension FirstViewAdvancedViewController : UISearchBarDelegate {
    private func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        AdvancedArray = AdvancedArray?.filter("TitleAdvanc CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "TitleAdvanc", ascending: true)
        self.tableAdvanced.reloadData()
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            load()
            tableAdvanced.reloadData()
            DispatchQueue.main.async {
                self.search.resignFirstResponder()
            }
            
        }
    }
    
    
}

