//
//  ItemListViewController.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/2/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import RealmSwift

class ItemListViewController: UIViewController {
    
    @IBOutlet weak var ItemTable: UITableView!
    
    
    
    
    let realm = try! Realm()
    var itemArray: Results<ListItem>?
    var selectedList: CategoryList? {
        didSet{
            load()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        load()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Load Realm
    func load(){
        
        itemArray = selectedList?.ParentList.sorted(byKeyPath: "ListTitle", ascending: true)
       
       // ItemTable.reloadData()
    }
    
    // MARK: - save Realm
    func save(item: ListItem) {
        do{
            try  realm.write{
                realm.add(item)
            }
            
        }catch{
            
            print("Error in reading data : \(error)")
        }
       // ItemTable.reloadData()
    }

    // MARK: - add items
    @IBAction func addItems(_ sender: Any) {
        var textCell = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            if textCell.text! != "" {
                do{
                    try self.realm.write {
                        let NewFolder = ListItem()
                        NewFolder.ListDate = Date()
                        NewFolder.ListTitle = textCell.text!
                        self.selectedList?.ParentList.append(NewFolder)
                    }
                }catch{
                    print("Error Savinge done status\(error)")
                }
                self.ItemTable.reloadData()
            }
            
           
        }))
        alert.addTextField { (alertTextField) in alertTextField.placeholder = "Create new Item"; textCell = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        ItemTable.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
// MARK: - Extension
extension ItemListViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellItem", for: indexPath) as! ItemListViewCell
        
        cell.Title.text = itemArray?[indexPath.row].ListTitle
        cell.accessoryType  = (itemArray?[indexPath.row].Status)! ?  .checkmark : .none
        
        if itemArray?[indexPath.row].Status == true {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (itemArray?[indexPath.row].ListTitle)!)
             attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.Title.attributedText = attributeString
        }else{
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (itemArray?[indexPath.row].ListTitle)!)
            attributeString.addAttribute(NSAttributedString.Key.accessibilityTextCustom, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.Title.attributedText = attributeString
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do{
           try realm.write {
                itemArray?[indexPath.row].Status = !(itemArray?[indexPath.row].Status)!
            }
            
        }catch{
             print("Error Savinge done status\(error)")
        }
       ItemTable.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if let item = itemArray?[indexPath.row] {
                
                do{
                    try realm.write {
                        realm.delete(item)
                    }
                    
                }catch{
                    print("Error Savinge done status\(error)")
                }
                ItemTable.reloadData()
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
}
