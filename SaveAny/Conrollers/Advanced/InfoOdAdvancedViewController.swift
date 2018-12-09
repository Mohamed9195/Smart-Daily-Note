//
//  InfoOdAdvancedViewController.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/9/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit
import AVFoundation
import RealmSwift
import CoreLocation

class InfoOdAdvancedViewController: UIViewController {

    @IBOutlet weak var TiltleInfo: UILabel!
    @IBOutlet weak var tableList: UITableView!
    @IBOutlet weak var tableAudio: UITableView!
    @IBOutlet weak var collectionPhoto: UICollectionView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var not: UITextView!
    
    var locationManger = CLLocationManager()
    
    //MARK: - For recorder
    var RecourderSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var Status = false
    
    
    let realm = try! Realm()
    
    var selectedAdvanced: AdvancedModel? {
        didSet{
            print(selectedAdvanced as Any)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        
        not.dataDetectorTypes = .all
        tableList.rowHeight = UITableView.automaticDimension
        tableAudio.rowHeight = UITableView.automaticDimension
        
        TiltleInfo.text = selectedAdvanced?.TitleAdvanc
        not.text = selectedAdvanced?.Note

        // Do any additional setup after loading the view.
    }
    
    //MARK: - thims
    func thimsView(){
        tableAudio.layer.borderWidth = 0.5
        tableAudio.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        tableAudio.layer.cornerRadius = 10
        
        tableList.layer.borderWidth = 0.5
        tableList.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        tableList.layer.cornerRadius = 10
        
        map.layer.borderWidth = 0.5
        map.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        map.layer.cornerRadius = 10
        
        collectionPhoto.layer.borderWidth = 0.5
        collectionPhoto.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        collectionPhoto.layer.cornerRadius = 10
        
        not.layer.borderWidth = 0.5
        not.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        not.layer.cornerRadius = 10
        
        TiltleInfo.layer.borderWidth = 0.5
        TiltleInfo.layer.borderColor = #colorLiteral(red: 0, green: 0.3411764706, blue: 0.5725490196, alpha: 1)
        TiltleInfo.layer.cornerRadius = 10
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - get path to directory
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }

}



//********************************************************************
//MARK: - Extension for table view
extension InfoOdAdvancedViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableAudio {
            return selectedAdvanced?.AudioRecording.count ?? 1
        }else{
            return selectedAdvanced?.SubTaskTitleAdvanc.count ?? 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableList {
            
             let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.accessoryType  = (selectedAdvanced?.SubTaskTitleAdvanc[indexPath.row].SubTaskStatus)! ?  .checkmark : .none
            cell.textLabel?.text = selectedAdvanced?.SubTaskTitleAdvanc[indexPath.row].TitleSubTask
            if selectedAdvanced?.SubTaskTitleAdvanc[indexPath.row].SubTaskStatus == true {
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (selectedAdvanced?.SubTaskTitleAdvanc[indexPath.row].TitleSubTask)!)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.textLabel!.attributedText = attributeString
            }else{
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (selectedAdvanced?.SubTaskTitleAdvanc[indexPath.row].TitleSubTask)!)
                attributeString.addAttribute(NSAttributedString.Key.accessibilityTextCustom, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.textLabel!.attributedText = attributeString
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = selectedAdvanced?.AudioRecording[indexPath.row].TitleSubTask
            
            return cell
        }
       
        
     
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableAudio {
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
            do{
                try realm.write {
                    selectedAdvanced?.SubTaskTitleAdvanc[indexPath.row].SubTaskStatus = !(selectedAdvanced?.SubTaskTitleAdvanc[indexPath.row].SubTaskStatus)!
                }
                
            }catch{
                print("Error Savinge done status\(error)")
            }
            tableList.reloadData()
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        
    }
    
    
}




//********************************************************************
//MARK: - Extension for Map view
extension InfoOdAdvancedViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManger.stopUpdatingLocation()
            locationManger.delegate = nil
          
            reloadMap()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fatalError("not found location")
    }
    func reloadMap(){
        
        
        let noLocation = CLLocationCoordinate2D(latitude: (selectedAdvanced?.lat)!, longitude: (selectedAdvanced?.long)!)
        let viewRegion = MKCoordinateRegion(center: noLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
        map.setRegion(viewRegion, animated: false)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = noLocation
        annotation.title = "work notation"
        annotation.subtitle = "her"
        map.addAnnotation(annotation)
        
    }
}




//********************************************************************
//MARK: - Extension for collection view
extension InfoOdAdvancedViewController: UICollectionViewDelegate ,UICollectionViewDataSource{
    
    
 
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedAdvanced?.photoAdvanc.count ?? 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionPhoto.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoInInfoCollectionViewCell
        cell.photo.image = UIImage(data: (selectedAdvanced?.photoAdvanc[indexPath.row].TitleSubTask)!)
        
        return cell
        
    }
    
    
}

