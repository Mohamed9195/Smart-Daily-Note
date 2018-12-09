//
//  AudioViewController.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/1/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import AVFoundation


class AudioViewController: UIViewController , AVAudioRecorderDelegate{
    
    var RecourderSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    
    var numberOfrecords = 0
    var Status = false
    var timeDuration =  0.0
    var startTime = 0.0
    var timer = Timer()
    
    @IBOutlet weak var Buttonlable: UIButton!
    @IBOutlet weak var CounterTime: UILabel!
    @IBOutlet weak var tableShowRecord: UITableView!
    
    //MARK: - Record now
    @IBAction func Record(_ sender: Any) {
        
        //check if we active recorder
        if audioRecorder == nil{
            numberOfrecords += 1

            let filename = getDirectory().appendingPathComponent("Record (\(numberOfrecords)).m4a")
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1 , AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // start recording
            do{
                
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                
                Buttonlable.setTitle("Stop record", for: .normal)
                
                print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                
                 timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(AudioViewController.updateRecord), userInfo: nil, repeats: true)
            }catch{
                dispalyAlert(title: "error!", Message: "recorder faild")
            }
        }else{
            // stope recorder
            audioRecorder.stop()
            audioRecorder = nil
            
            timer.invalidate()
            CounterTime.text = "--:--"
            
            UserDefaults.standard.set(numberOfrecords, forKey: "myNumber")
            tableShowRecord.reloadData()
            Buttonlable.setTitle("record", for: .normal)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Setting Sission
        RecourderSession = AVAudioSession.sharedInstance()
        
        if let number: Int = UserDefaults.standard.object(forKey: "myNumber") as? Int {
            numberOfrecords = number
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            print("Accept")
        }
        
        print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // Do any additional setup after loading the view.
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
    
     //MARK: -  dispaly counter time
    @objc func update()  {
        startTime += 0.5
        if timeDuration >= startTime {
            CounterTime.text = String(startTime)
        }else{
            CounterTime.text = "--.--"
            Status = !Status
        }
        
    }
    @objc func updateRecord()  {
            startTime += 0.5
            CounterTime.text = String(startTime)
        
        
    }
    

}

//MARK: - extension

extension AudioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfrecords
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Record (\(indexPath.row + 1)).m4a"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Status = !Status
        startTime = 0.0
        let path = getDirectory().appendingPathComponent("Record (\(indexPath.row + 1)).m4a")
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
            timeDuration = audioPlayer.duration
            
            
        }catch{
           fatalError("not show")
        }
        if Status == true {
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(AudioViewController.update), userInfo: nil, repeats: true)
            audioPlayer.play()
            
        }else{
            audioPlayer.stop()
            timer.invalidate()
            CounterTime.text = "--:--"
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
}
