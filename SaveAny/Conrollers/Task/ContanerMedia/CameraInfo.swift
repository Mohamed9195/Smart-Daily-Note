//
//  CameraInfo.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/2/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import RealmSwift

class CameraInfo: UIViewController {

    @IBOutlet weak var DonButtom: UIButton!
    @IBOutlet weak var editButtom: UIButton!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var info: UITextView!
    
    let realm = try! Realm()
    var infoArray: PhotoDataBase?
    
    var selectedphoto: PhotoDataBase? {
        didSet{
            
            load()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        info.dataDetectorTypes = .all
        
        if let data = infoArray {
            photo.image = UIImage(data: data.Picture!)
            info.text = data.CreateDate.description + "\n"  + data.Information
        }
         info.isEditable = false
        DonButtom.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Load Realm
    func load(){
        
        infoArray = selectedphoto
    
        
    }
   // MARK: - save Realm
    func save() {
        
        do{
            try  realm.write {
                infoArray?.Information = info.text
                infoArray?.CreateDate = Date()
            }
            
        }catch{
            
            print("Error in reading data : \(error)")
        }
        
    }
    @IBAction func Edit(_ sender: Any) {
        DonButtom.isHidden = false
        editButtom.isHidden = true
        info.isEditable = true
        
    }
    
    @IBAction func Done(_ sender: Any) {
        DonButtom.isHidden = true
        editButtom.isHidden = false
        info.isEditable = false
        save()
    }
    
}
