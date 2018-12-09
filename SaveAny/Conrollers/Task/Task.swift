//
//  Task.swift
//  SaveAny
//
//  Created by mohamed hashem on 11/29/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class Task: UIViewController {
    
    @IBOutlet weak var ControlviewFolder: UICollectionView!
    @IBOutlet weak var AddFolder: UIBarButtonItem!
    
    
    let realm = try! Realm()
    var ListData: Results<CategoryList>?
    var FolderArray: Results<Folder>?
    var DeltetedFolder: Results<DeletedData>?
    var Fixdtopic = ["Media" , "List" , "Trash" ]
    
    var path = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert , .badge , .sound ]) { (didAllow, error) in }
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        load()
        
        // navigationItem.leftBarButtonItem = editButtonItem
        
        let longPressgester = UILongPressGestureRecognizer(target: self, action: #selector(DeleteCategory))
        ControlviewFolder.addGestureRecognizer(longPressgester)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ControlviewFolder.reloadData()
    }
    
    
    // MARK: - Delete Item by gester
    @objc func DeleteCategory(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.ControlviewFolder)
            if let indexpath = ControlviewFolder.indexPathForItem(at: touchPoint) {
                
                
                let alert = UIAlertController(title: "Delete Folder", message: "You Sure to Delete Folder", preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
                    
                    if indexpath.row < 3{
                        
                    }else{
                        
                        if self.FolderArray?[indexpath.row - 3] != nil  {
                            let deleted_Object = DeletedData()
                            deleted_Object.Delted_Date = Date()
                            
                            deleted_Object.Name = (self.FolderArray?[indexpath.row - 3].Title)!
                            
                            do{
                                try self.realm.write {
                                    self.realm.add(deleted_Object)
                                    self.realm.delete((self.FolderArray?[indexpath.row - 3])!)
                                    self.ControlviewFolder.reloadData()
                                }
                                
                            }catch{
                                print("Error Savinge done status\(error)")
                            }
                            self.ControlviewFolder.reloadData()
                        }
                    }
                    
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    
    //MARK: - avigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addfolder"{
            let vcs = segue.destination as! AddTask
            vcs.Saving = {
                self.ControlviewFolder.reloadData()
                
            }
        }else if segue.identifier == "toTrash"
        {
            
        }else if segue.identifier == "tomedia"
        {
            
        }else if segue.identifier == "tolist"
        {
            
        }else{
            let destinationVC = segue.destination as! ShowDataInFolder
            destinationVC.selectedFolder = FolderArray?[path]
        }
    }
    
    
    // MARK: - Save Realm
    func Save(Folder: Folder){
        do{
            try realm.write {
                realm.add(Folder)
            }
        }catch{
            print("Error in reading data : \(error)")
        }
        ControlviewFolder.reloadData()
    }
    
    
    // MARK: - Load Realm
    func load(){
        FolderArray = realm.objects(Folder.self)
        DeltetedFolder = realm.objects(DeletedData.self)
        ListData = realm.objects(CategoryList.self)
        ControlviewFolder.reloadData()
    }
    
    // MARK: - Delete Item by SetEditing
    
        override func setEditing(_ editing: Bool, animated: Bool) {
//            super.setEditing(editing, animated: true)
//
//                AddFolder.isEnabled = !editing
//                if let index = ControlviewFolder?.indexPathsForVisibleItems{
//
//                    for i in index {
//                        if let cell = ControlviewFolder.cellForItem(at: i) as? FolderCell {
//
//                            cell.isEditings = editing
//                            cell.delegte = self
//
//                        }
//                    }
//                }
    
        }
    
    
}
// MARK: - Extension
extension Task : UICollectionViewDelegate , UICollectionViewDataSource , deleteCellFolder{
    // Delegate to delete Cell
    func delete(cell: FolderCell) {
//                if let cell = ControlviewFolder.indexPath(for: cell){
//                    if cell.row < 3{
//
//                    }else{
//
//                        if FolderArray?[cell.row - 3] != nil  {
//                            let deleted_Object = DeletedData()
//                            deleted_Object.Delted_Date = Date()
//                            print(Date())
//                            deleted_Object.Name = (FolderArray?[cell.row - 3].Title)!
//                            print((FolderArray?[cell.row - 3].Title)!)
//                            do{
//                                try realm.write {
//                                    realm.add(deleted_Object)
//                                    realm.delete((FolderArray?[cell.row - 3])!)
//
//                                }
//
//                            }catch{
//                                print("Error Savinge done status\(error)")
//                            }
//
//                        }
//                    }
//                }
//                ControlviewFolder.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        var temnumber = Fixdtopic.count + FolderArray!.count
        //        if temnumber < 10 {
        //            return temnumber
        //        }else {
        //            return 10
        //        }
        //
        return Fixdtopic.count + FolderArray!.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ControlviewFolder.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FolderCell
        editeCell(cell: cell)
        
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2{
            if indexPath.row == 2 {
                cell.namecell.text = Fixdtopic[indexPath.row]
                cell.numberItem.text = String(DeltetedFolder?.count ?? 0)
                //cell.backgroundColor = #colorLiteral(red: 0.9523111979, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
                cell.namecell.font = UIFont(name: Fixdtopic[indexPath.row], size: 25)
                return cell
            }else if indexPath.row == 1{
                cell.namecell.text = Fixdtopic[indexPath.row]
                cell.numberItem.text = String(ListData?.count ?? 0 )
               // cell.backgroundColor = #colorLiteral(red: 0.6235294118, green: 0.9098039216, blue: 0.9803921569, alpha: 0.5)
                cell.namecell.font = UIFont(name: Fixdtopic[indexPath.row], size: 25)
                return cell
            }else{
                cell.namecell.text = Fixdtopic[indexPath.row]
                cell.numberItem.text = ""
              //  cell.backgroundColor = #colorLiteral(red: 0.8705882353, green: 0.9254901961, blue: 1, alpha: 0.5)
                cell.namecell.font = UIFont(name: Fixdtopic[indexPath.row], size: 25)
                return cell
            }
            
        }else{
            
            // cell.DeleteButton.isHidden = cell.isEditings
            cell.namecell.text = FolderArray?[indexPath.row - 3].Title
            cell.numberItem.text = String(FolderArray![indexPath.row - 3].childfolder.count)
            //cell.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.9019607843, blue: 0.7568627451, alpha: 0.7042754709)
            //UIColor(red: 222, green: 236, blue: 252, alpha: 0.5)
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row > 2 {
            path = Int(indexPath.row) - 3
            performSegue(withIdentifier: "qq", sender: self)
        }else if indexPath.row == 2{
            path = Int(indexPath.row)
            performSegue(withIdentifier: "toTrash", sender: self)
        }else if indexPath.row == 0 {
            path = Int(indexPath.row)
            performSegue(withIdentifier: "tomedia", sender: self)
        }else if indexPath.row == 1 {
            path = Int(indexPath.row)
            performSegue(withIdentifier: "tolist", sender: self)
        }
        
    }
    
    
    
    
    
    
    func editeCell(cell: UICollectionViewCell){
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        cell.layer.cornerRadius = 10
    }
}
