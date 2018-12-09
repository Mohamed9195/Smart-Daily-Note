//
//  AdvancedModel.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/8/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import Foundation
import RealmSwift

class AdvancedModel : Object{
    
    @objc dynamic var TitleAdvanc : String = ""
    var SubTaskTitleAdvanc =  List<SubList>()
    @objc dynamic var SubTaskStatusAdvanc : Bool = false
    var photoAdvanc =  List<subphoto>()
    var AudioRecording = List<subAudio>()
    @objc dynamic var lat : Double = 0.0
    @objc dynamic var long : Double = 0.0
    @objc dynamic var AlarmRing : Date = Date()
    @objc dynamic var Note : String = ""
    @objc dynamic var CreateDate : Date = Date()
    @objc dynamic var WillFinishDate : Date = Date()
    
    
    
    
}
