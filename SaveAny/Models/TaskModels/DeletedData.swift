//
//  DeletedData.swift
//  SaveAny
//
//  Created by mohamed hashem on 11/30/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import Foundation
import RealmSwift

class DeletedData : Object{
    
    @objc dynamic var Name : String = ""
    @objc dynamic var Delted_Date : Date = Date()
 
    
    
    
    
}
