//
//  CamiraViewController.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/1/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import RealmSwift

class CamiraViewController: UIViewController {
    
    let realm = try! Realm()
    var photoArray: Results<PhotoDataBase>?
    var arrayPhoto : [UIImage] = []
    
    let picker = UIImagePickerController()
    let pickerGalary = UIImagePickerController()
    
    var photoTacked = UIImage()
    var path = 0
    
    
    @IBOutlet weak var CollectionCamera: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        
        
        pickerGalary.delegate = self
        pickerGalary.allowsEditing = false
        pickerGalary.sourceType = .photoLibrary
        
        load()
        self.CollectionCamera.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
      //MARK: - Galary
    @IBAction func Galary(_ sender: Any) {
         present(pickerGalary, animated: true, completion: nil)
    }
    
    //MARK: - tackePhoto
    @IBAction func tackePhoto(_ sender: Any) {
        present(picker, animated: true, completion: nil)
        
    }
    
    // MARK: - Load Realm
    func load(){
        
        photoArray =  realm.objects(PhotoDataBase.self)
        if photoArray != nil {
        for  i in photoArray! {
            arrayPhoto.append(UIImage(data: i.Picture!)!)
            print(UIImage(data: i.Picture!)!)
            
        }
            print("hamadammmmmmm")
            
        }
      print(arrayPhoto)
        self.CollectionCamera.reloadData()
    }
    
    // MARK: - save Realm
    func save(photo: PhotoDataBase) {
        
        do{
            try  realm.write {
                realm.add(photo)
            }
            
        }catch{
            
            print("Error in reading data : \(error)")
        }
        CollectionCamera.reloadData()
    }

    
   //MARK: - Navigatin
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToInfoPhoto"{
            let vcs = segue.destination as! CameraInfo
             vcs.selectedphoto = photoArray?[path]
        }
    }
    
    
}

//MARK: - Extension
extension CamiraViewController: UICollectionViewDelegate ,UICollectionViewDataSource, UINavigationControllerDelegate , UIImagePickerControllerDelegate{
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            arrayPhoto.append(photo)
            
            let imageData = photo.jpegData(compressionQuality: 0.01)
            
            let newObjectPhoto = PhotoDataBase()
            newObjectPhoto.CreateDate = Date()
            newObjectPhoto.Information = "not found"
            newObjectPhoto.Picture = imageData
            save(photo: newObjectPhoto)
            
            
//            guard let ciimage = CIImage(image: photo) else {
//                fatalError("Code not Convert to CIImage")
//            }
            picker.dismiss(animated: true, completion: nil)
            self.CollectionCamera.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPhoto.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = CollectionCamera.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CamiraCell
        cell.l.text = Date().description
        cell.Photo.image = arrayPhoto[indexPath.row]
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        path = Int(indexPath.row)
        performSegue(withIdentifier: "ToInfoPhoto", sender: self)
        
    }
    
    
}
