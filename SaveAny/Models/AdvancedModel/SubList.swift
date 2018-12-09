//
//  SubList.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/9/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import Foundation
import RealmSwift

class SubList : Object{
    
    @objc dynamic var TitleSubTask : String = ""
    @objc dynamic var SubTaskStatus : Bool = false
    var Connection = LinkingObjects(fromType: AdvancedModel.self, property: "SubTaskTitleAdvanc")
   
    
    
    
    
}
