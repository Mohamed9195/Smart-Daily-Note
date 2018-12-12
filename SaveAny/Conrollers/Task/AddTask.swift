//
//  AddTask.swift
//  SaveAny
//
//  Created by mohamed hashem on 11/29/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import RealmSwift

class AddTask: UIViewController {
    
    @IBOutlet weak var textNewFolder: UIView!
    @IBOutlet weak var titletext: UITextField!
    
    var Saving: (()->())?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titletext.isSelected = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Cansl(_ sender: Any) {
        if titletext.text != "" {
            if let title = titletext.text {
                let NewFolder = Folder()
                NewFolder.Title = title
                try! realm.write {
                    realm.add(NewFolder)
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
    //self.navigationController?.popToRootViewController(animated: true)
     dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func dismisView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
