//
//  subphoto.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/9/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import Foundation
import RealmSwift

class subphoto : Object{
    
    @objc dynamic var TitleSubTask : Data = Data()
    var Connection = LinkingObjects(fromType: AdvancedModel.self, property: "photoAdvanc")
    
    
    
    
    
}
