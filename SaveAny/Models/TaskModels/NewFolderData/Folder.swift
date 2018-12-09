//
//  Folder.swift
//  SaveAny
//
//  Created by mohamed hashem on 11/29/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import Foundation
import RealmSwift

class Folder : Object{
    
    @objc dynamic var Title : String = ""
    @objc dynamic var Create_Date : Date = Date()
    let childfolder = List<ChildFolder>()
    
  
    
}
