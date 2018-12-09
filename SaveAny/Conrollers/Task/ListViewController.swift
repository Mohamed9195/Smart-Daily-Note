//
//  ListViewController.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/2/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController {

    @IBOutlet weak var listTable: UITableView!
  
    
    var path = 0
    
    let realm = try! Realm()
    var listArray: Results<CategoryList>?
    override func viewDidLoad() {
        super.viewDidLoad()

        let longPressgester = UILongPressGestureRecognizer(target: self, action: #selector(EditCategory))
        listTable.addGestureRecognizer(longPressgester)
        
        load()
        listTable.separatorStyle = .none
        listTable.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Load Realm
    func load(){
        
        listArray = realm.objects(CategoryList.self)
        // myTable.reloadData()
        
    }
    
    
    // MARK: - save Realm
    func save(list: CategoryList) {
        do{
            try  realm.write {
                realm.add(list)
            }
            
        }catch{
            
            print("Error in reading data : \(error)")
        }
        //  myTable.reloadData()
    }
    
    @IBAction func addlist(_ sender: Any) {
        
        var textCell = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            if textCell.text! != "" {
                
                
                    let NewFolder = CategoryList()
                    NewFolder.ListTitle = textCell.text!
                    NewFolder.ListDate = Date()
                self.save(list: NewFolder)
                self.listTable.reloadData()
            }
            
        }))
        alert.addTextField { (alertTextField) in alertTextField.placeholder = "Create new Item"; textCell = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        listTable.reloadData()
        
    }
    
    // MARK: - Edit cell
   
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toitemInlist"{
            let destinationVC = segue.destination as! ItemListViewController
            destinationVC.selectedList = listArray?[path]
        }
    }
    
    
    // MARK: - Edit Item by gester
    @objc func EditCategory(_ gestureRecognizer: UILongPressGestureRecognizer) {
        var textCell = UITextField()
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.listTable)
            if let indexpath = listTable.indexPathForRow(at: touchPoint){
                
                
                let alert = UIAlertController(title: "Change name", message: "", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
                    

                            do{
                                try self.realm.write {
                                   self.listArray?[indexpath.row].ListTitle = textCell.text!
                                    self.listArray?[indexpath.row].ListDate = Date()
                                }
                            }catch{
                                print("Error Savinge done status\(error)")
                            }
                            self.listTable.reloadData()
                }))
                alert.addTextField { (alertTextField) in alertTextField.placeholder = "Edit name"; textCell = alertTextField
                }
                
                present(alert, animated: true, completion: nil)
                
            }
            
        }
        
    }
 

}
 // MARK: - extension
extension ListViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return listArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListViewCell
        
        cell.name.text = listArray?[indexPath.row].ListTitle
        cell.date.text = listArray?[indexPath.row].ListDate.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        path = Int(indexPath.row)
        performSegue(withIdentifier: "toitemInlist", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
           
            if let item = listArray?[indexPath.row] {
                
                do{
                    try realm.write {
                        realm.delete(item)
                    }
                    
                }catch{
                    print("Error Savinge done status\(error)")
                }
            listTable.reloadData()
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
}
