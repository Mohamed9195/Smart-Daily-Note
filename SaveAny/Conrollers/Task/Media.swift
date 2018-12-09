//
//  Media.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/1/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import RealmSwift

class Media: UIViewController {

    @IBOutlet weak var contanerVideo: UIView!
    @IBOutlet weak var contanerCamira: UIView!
    @IBOutlet weak var contanerAudio: UIView!
    @IBOutlet weak var contanerRecognize: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contanerVideo.isHidden = false
        contanerCamira.isHidden = true
        contanerAudio.isHidden = true
        contanerRecognize.isHidden = true
        // Do any additional setup after loading the view.
    }
    
  
    @IBAction func whenTaped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            contanerVideo.isHidden = false
            contanerCamira.isHidden = true
            contanerAudio.isHidden = true
            contanerRecognize.isHidden = true
            
        }else if sender.selectedSegmentIndex == 1 {
            contanerVideo.isHidden = true
            contanerCamira.isHidden = false
            contanerAudio.isHidden = true
            contanerRecognize.isHidden = true
        }else if sender.selectedSegmentIndex == 2 {
            contanerVideo.isHidden = true
            contanerCamira.isHidden = true
            contanerAudio.isHidden = true
            contanerRecognize.isHidden = false
        }else{
            contanerVideo.isHidden = true
            contanerCamira.isHidden = true
            contanerAudio.isHidden = false
            contanerRecognize.isHidden = true
        }
    }
    
   
    // MARK: - Navigation


}
