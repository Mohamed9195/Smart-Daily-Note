//
//  AdvancedViewController.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/8/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift
import CoreLocation
import MapKit
import UserNotifications



class AdvancedViewController: UIViewController ,AVAudioRecorderDelegate{
    
    let realm = try! Realm()
    var Saving: (()->())?
    
    let AdvancedData = AdvancedModel()
   
    var arrayPhoto : [UIImage] = []
    var arrayList  : [String]  = []
    
    let picker = UIImagePickerController()
    var photoTacked = UIImage()
    
    //MARK: -  layOut
    @IBOutlet weak var TitleOfAdvanced: UITextField!
    @IBOutlet weak var AddListbutton: UIButton!
    @IBOutlet weak var tableList: UITableView!
    @IBOutlet weak var collectionphoto: UICollectionView!
    @IBOutlet weak var addPhotobutton: UIButton!
    @IBOutlet weak var AddNewRecordButton: UIButton!
    @IBOutlet weak var tableRecorder: UITableView!
    @IBOutlet weak var alarmPicker: UIDatePicker!
    @IBOutlet weak var textForNote: UITextView!
    @IBOutlet weak var map: MKMapView!
    var locationManger = CLLocationManager()
    
    //MARK: -  Views
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var recoredView: UIView!
    @IBOutlet weak var alarmView: UIView!
    
    
    //MARK: - For recorder
    var RecourderSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var numberOfrecords = 0
    var Status = false
    
    var Longtut  = 0.0
    var Latitut  = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textForNote.dataDetectorTypes = .all
        
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        
        
        // Do any additional setup after loading the view.
        tableRecorder.rowHeight = UITableView.automaticDimension
        tableList.rowHeight = UITableView.automaticDimension
        
        
        //Setting Sission for record
        RecourderSession = AVAudioSession.sharedInstance()
        if let number: Int = UserDefaults.standard.object(forKey: "myNumbers") as? Int {
            numberOfrecords = number
        }
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            print("Accept")
        }
        
        print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Setup Thimse
        thimsView()
    }
    //MARK: - thims
    func thimsView(){
        titleView.layer.borderWidth = 0.5
        titleView.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        titleView.layer.cornerRadius = 10
        
        listView.layer.borderWidth = 0.5
        listView.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        listView.layer.cornerRadius = 10
        
        photoView.layer.borderWidth = 0.5
        photoView.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        photoView.layer.cornerRadius = 10
        
        recoredView.layer.borderWidth = 0.5
        recoredView.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        recoredView.layer.cornerRadius = 10
        
        alarmView.layer.borderWidth = 0.5
        alarmView.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        alarmView.layer.cornerRadius = 10
    }
    
    
       //MARK: - GetLocation
    @IBAction func GetLocation(_ sender: Any) {
        
         var textCelllat = UITextField()
         var textCelllong = UITextField()
        let alert = UIAlertController(title: "Enter Posetion", message: "First Long , Secound Lat", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            if textCelllat.text! != "" {
                self.Latitut = Double(textCelllat.text!)!
            }
            if textCelllong.text! != "" {
                self.Longtut = Double(textCelllong.text!)!
            }
            self.reloadMap()
            
        }))
        alert.addTextField { (alertTextField) in alertTextField.placeholder = "PUT LAT"; textCelllat = alertTextField
        }
        alert.addTextField { (alertTextField) in alertTextField.placeholder = "PUT LONG"; textCelllong = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        reloadMap()
    }
    
    
    
    //MARK: - AddNewList
    @IBAction func AddNewList(_ sender: Any) {
       
        var textCell = UITextField()
        let alert = UIAlertController(title: "Enter Your Item", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            if textCell.text! != "" {
                self.arrayList.append(textCell.text!)
                do{
                    try self.realm.write {
                         let subTaskList  = SubList()
                         subTaskList.TitleSubTask = textCell.text!
                          self.realm.add(subTaskList)
                        self.AdvancedData.SubTaskTitleAdvanc.append(subTaskList)
                    }
                }catch{
                    
                }
                
            }
            
            self.tableList.reloadData()
            
            
        }))
        alert.addTextField { (alertTextField) in alertTextField.placeholder = "PUT YOur Itme"; textCell = alertTextField
        }
        
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - AddRecord
    @IBAction func AddRecord(_ sender: Any) {
        //check if we active recorder
        if audioRecorder == nil{
            numberOfrecords += 1
            
            let filename = getDirectory().appendingPathComponent("AdvancedRecord (\(numberOfrecords)).m4a")
            
            
            do{
                try self.realm.write {
                    let subTaskaudio  = subAudio()
                    subTaskaudio.TitleSubTask = filename.scheme!
                    self.realm.add(subTaskaudio)
                    self.AdvancedData.AudioRecording.append(subTaskaudio)
                }
            }catch{
                
            }
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1 , AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // start recording
            do{
                
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                
                AddNewRecordButton.setTitle("Stop record", for: .normal)
                
                print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                
                
            }catch{
                dispalyAlert(title: "error!", Message: "recorder faild")
            }
        }else{
            // stope recorder
            audioRecorder.stop()
            audioRecorder = nil
            
            
            UserDefaults.standard.set(numberOfrecords, forKey: "myNumbers")
            tableRecorder.reloadData()
            AddNewRecordButton.setTitle("record", for: .normal)
        }
    }
    
    //MARK: - get path to directory
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    //MARK: -  dispaly an alert if error
    func dispalyAlert(title: String , Message: String) {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - addNewPhoto
    @IBAction func addNewPhoto(_ sender: Any) {
         present(picker, animated: true, completion: nil)
    }
    
    //MARK: - addAlarm
    @IBAction func DoAlarmForTimeFinish(_ sender: Any) {
        
        do{
            try self.realm.write {
                self.AdvancedData.WillFinishDate = alarmPicker.date
            }
        }catch{
            
        }
        
        
        let humi = alarmPicker.calendar.dateComponents([.hour, .minute , .day , .era , .month , .year ], from: alarmPicker.date)
        let hour = humi.hour
        let minute = humi.minute
        let day = humi.day
        
        let currentDate = Date()
        let currentCalender = Calendar.current
        let c1 = currentCalender.component(.day , from: currentDate)
        let c2 = currentCalender.component(.minute , from: currentDate)
        let c3 = currentCalender.component(.hour , from: currentDate)
        
        let DayOfalarm = day! - c1
        let hourOfalarm = hour! - c3
        let minuteOfalarm = minute! - c2
        
        print(DayOfalarm)
        print(hourOfalarm)
        print(minuteOfalarm)
        

            let content = UNMutableNotificationContent()
            content.title = "DoAny"
            content.body = "😀 Thank's For Using App"
            content.subtitle = "Your Note Shoud Finished"
            content.sound = UNNotificationSound.defaultCritical
            
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval:(TimeInterval(hourOfalarm * 60 + minuteOfalarm * 60 + DayOfalarm * 24 )), repeats: false)
        
         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            let request = UNNotificationRequest(identifier: "TimerDone", content: content, trigger: trigger)
            
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
       
    }
    
    //MARK: - SaveEvery
    //***********************************************************
    @IBAction func SaveEvery(_ sender: Any) {
        do{
            try self.realm.write {
                AdvancedData.TitleAdvanc = TitleOfAdvanced.text ?? "not enter name"
                AdvancedData.CreateDate = Date()
                AdvancedData.Note = textForNote.text!
                AdvancedData.long = Longtut
                AdvancedData.lat = Latitut
                AdvancedData.WillFinishDate = alarmPicker.date
                AdvancedData.AlarmRing = alarmPicker.date
                
            }
        }catch{
            
        }
        //let newAdvancid = AdvancedModel()
        
       
        /*
        for photo do it in Delegate
        AdvancedData?.photoAdvanc?.append(imageData!)
        */
       

        do{
            try  realm.write {
                realm.add(AdvancedData)
                
            }
        }catch{
            print("not record")
        }
        if let saving = Saving {
            saving()
        }
        dismiss(animated: true, completion: nil)
    }
    //***********************************************************
}




//********************************************************************
//MARK: - extension For table
extension AdvancedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableRecorder{
            return numberOfrecords
        }else{
            return arrayList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableRecorder{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "AdvancedRecord (\(indexPath.row + 1)).m4a"
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListInsertTableViewCell
            cell.lableList.text = arrayList[indexPath.row]
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableRecorder{
            Status = !Status
            let path = getDirectory().appendingPathComponent("AdvancedRecord (\(indexPath.row + 1)).m4a")
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: path)
                audioPlayer.play()
            }catch{
                fatalError("not show")
            }
            if Status == true {
                audioPlayer.play()
                
            }else{
                audioPlayer.stop()
            }
        }else{
            
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == tableRecorder {
            if editingStyle == .delete {
                
            }
        }else{
            if editingStyle == .delete {
                arrayList.remove(at: indexPath.row)
                do{
                  try  realm.write {
                    AdvancedData.SubTaskTitleAdvanc.remove(at: indexPath.row)
                    }
                }catch{
                    
                }
                
            }
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
}






//********************************************************************
//MARK: - Extension for collection view
extension AdvancedViewController: UICollectionViewDelegate ,UICollectionViewDataSource, UINavigationControllerDelegate , UIImagePickerControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            arrayPhoto.append(photo)
            let imageData = photo.jpegData(compressionQuality: 0.01)
            
            do{
                try  realm.write {
                    let subTaskphoto  = subphoto()
                    subTaskphoto.TitleSubTask = imageData!
                    self.realm.add(subTaskphoto)
                    AdvancedData.photoAdvanc.append(subTaskphoto)
                }
            }catch{
                
            }
            

       
            picker.dismiss(animated: true, completion: nil)
            self.collectionphoto.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPhoto.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionphoto.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell
        cell.photo.image = arrayPhoto[indexPath.row]
        return cell
        
    }
    
    
}


//********************************************************************
//MARK: - Extension for Map view
extension AdvancedViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManger.stopUpdatingLocation()
            locationManger.delegate = nil
            
            Longtut = Double(location.coordinate.longitude)
            Latitut = Double(location.coordinate.latitude)
            print(Longtut)
            print(Latitut)
            reloadMap()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fatalError("not found location")
    }
    func reloadMap(){
        
        
        let noLocation = CLLocationCoordinate2D(latitude: Latitut, longitude: Longtut)
        let viewRegion = MKCoordinateRegion(center: noLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
        map.setRegion(viewRegion, animated: false)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = noLocation
        annotation.title = "My Home"
        annotation.subtitle = "her"
        map.addAnnotation(annotation)
       
    }
}
