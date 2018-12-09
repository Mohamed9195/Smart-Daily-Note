//
//  FolderInfoViewController.swift
//  SaveAny
//
//  Created by mohamed hashem on 11/29/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import RealmSwift

class FolderInfoViewController: UIViewController {

    @IBOutlet weak var Saveitem: UIBarButtonItem!
    @IBOutlet weak var textinfo: UITextView!
    @IBOutlet weak var saveItemButton: UIBarButtonItem!
    
    let realm = try! Realm()
    var infoArray: ChildFolder?
    var selectedChildFolder: ChildFolder? {
        didSet{
            load()
        }
    }
    
    
    @IBOutlet weak var textInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         load()
         textInfo.dataDetectorTypes = .all
         textinfo.isEditable = false
         textInfo.text = infoArray?.Info
         navigationItem.title = infoArray?.Title
         Saveitem.title = ""
         Saveitem.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    
// MARK: - Load Realm
    func load(){
        
        infoArray = selectedChildFolder

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
       
    }

   
    @IBAction func saveIt(_ sender: Any) {
        if let item = infoArray {
            do{
                try self.realm.write {
                    
                    item.Create_Date = Date()
                    item.Info = textInfo.text
                }
            }catch{
                print("Error Savinge done status\(error)")
            }
        }
        Saveitem.title = ""
        Saveitem.isEnabled = false
        saveItemButton.isEnabled = true
        saveItemButton.title = "Edit"
        textinfo.isEditable = false
    }
    
    @IBAction func editInfo(_ sender: Any) {
        
       
            Saveitem.title = "Save"
            Saveitem.isEnabled = true
            saveItemButton.isEnabled = false
            saveItemButton.title = ""
            textinfo.isEditable = true
     
    }
}
