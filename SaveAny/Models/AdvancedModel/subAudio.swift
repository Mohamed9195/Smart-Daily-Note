//
//  subAudio.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/9/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import Foundation
import RealmSwift

class subAudio : Object{
    
    @objc dynamic var TitleSubTask : String = ""
    var Connection = LinkingObjects(fromType: AdvancedModel.self, property: "AudioRecording")
    
    
    
    
    
}
