//
//  AddListItem.swift
//  SaveAny
//
//  Created by mohamed hashem on 11/29/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import RealmSwift

class AddListItem: UIViewController {
    
    @IBOutlet weak var textInfo: UITextView!
    @IBOutlet weak var textTitle: UITextField!
    
    var Saving: (()->())?
    
    let realm = try! Realm()
    var selectedChildFolder1: Folder? {
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textTitle.isSelected = true
        textInfo.dataDetectorTypes = .all
        // Do any additional setup after loading the view.
    
    }
    
    
    @IBAction func save(_ sender: Any) {
        
        
        
        if textTitle.text != "" && textInfo.text != "" {
            if let title = textTitle.text, let Info = textInfo.text {
                
                try! realm.write {
                    let NewFolder = ChildFolder()
                    NewFolder.Title = title
                    NewFolder.Info = Info
                    selectedChildFolder1?.childfolder.append(NewFolder)
                }
            }
        }else{
            let aler = UIAlertController(title: "Missing", message: "complet missing data", preferredStyle: .actionSheet)
            aler.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            present(aler, animated: true, completion: nil)
        }
        
        if let saving = Saving {
            saving()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DisimisView(_ sender: Any) {
           dismiss(animated: true, completion: nil)
    }
}
