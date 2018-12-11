//
//  RecognizeViewController.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/1/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
//import CoreML
//import Vision
//import VisualRecognitionV3
//import SVProgressHUD

class RecognizeViewController: UIViewController {
    
//    //MARK: - setup data to IBM
//    let apiKey = "X1gX8iebxZFrEfxHgKiOkkpYarGmoyaT1UmiejGKhzFx"
//    let version = "2018-11-06"
//    
//    // array of classification
//    var classificationResults: [String] = []
//
//    @IBOutlet weak var gesster2: UITextView!
//    @IBOutlet weak var guesster1: UITextView!
//    @IBOutlet weak var photo: UIImageView!
//    
//    @IBOutlet weak var camira: UIButton!
//    @IBOutlet weak var galary: UIButton!
//    let picker = UIImagePickerController()
//    let pickerGalary = UIImagePickerController()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        picker.delegate = self
//        picker.allowsEditing = false
//        picker.sourceType = .photoLibrary
//        
//        
//        pickerGalary.delegate = self
//        pickerGalary.allowsEditing = false
//        pickerGalary.sourceType = .photoLibrary
//        
//        // Do any additional setup after loading the view.
//    }
//    
//
//    //MARK: - Tack photo
//    @IBAction func tackphoto(_ sender: Any) {
//         present(picker, animated: true, completion: nil)
//    }
//    
//     //MARK: - library photo
//    @IBAction func galary(_ sender: Any) {
//         present(pickerGalary, animated: true, completion: nil)
//    }
//    
//    
//     //MARK: - model one
//    func modelOne(image: CIImage){
//        
//        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
//             fatalError("Loading finish at faild")
//        }
//        
//        let request =  VNCoreMLRequest(model: model) { (request, error) in
//            
//            guard let result = request.results as? [VNClassificationObservation] else{
//                 fatalError("Model faled to prosse ")
//            }
//            
//            if let firstResult = result.first {
//                self.guesster1.text = firstResult.identifier
//            }
//            
//        }
//        
//        let handler = VNImageRequestHandler(ciImage: image)
//        do{
//          try  handler.perform([request])
//        }catch{
//            print("\(error)nnnnnnnn")
//        }
//    }
//    
//     //MARK: - model two
//    
//}
//
// //MARK: - extension
//extension RecognizeViewController :  UINavigationControllerDelegate , UIImagePickerControllerDelegate{
//    
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        
//        if let photopicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//       
//            photo.image = photopicked
//           // for model one
//            guard let ciimage = CIImage(image: photopicked) else {
//                fatalError("Code not Convert to CIImage")
//            }
//            
//            modelOne(image: ciimage)
//            
//            //for model two
//            
//            gesster2.text = ""
//            camira.isEnabled = false
//            galary.isEnabled = false
//            SVProgressHUD.show()
//            
//            let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
//            
//            // save photo in local and convert to Data (Binary data)
//            let imageData = photopicked.jpegData(compressionQuality: 0.01)
//            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let fileURL = documentsURL.appendingPathComponent("TempImage.jpg")
//            try? imageData?.write(to: fileURL, options: [])
//            
//            visualRecognition.classify(imagesFile: fileURL) { (ClassifiedImages) in
//                
//                let classes = ClassifiedImages.images.first!.classifiers.first!.classes
//                self.classificationResults = []
//                
//                for index in 1..<classes.count {
//                    self.classificationResults.append(classes[index].className)
//                    
//                    DispatchQueue.main.async {
//                        self.gesster2.text += self.classificationResults[index - 1] + " , "
//                    }
//                }
//                
//                // finish search data
//                DispatchQueue.main.async {
//                    self.camira.isEnabled = true
//                    self.galary.isEnabled = true
//                    SVProgressHUD.dismiss()
//                }
//                
//                
//            }
//            
//        }
//        
//        SVProgressHUD.dismiss()
//        picker.dismiss(animated: true, completion: nil)
//    }
}
