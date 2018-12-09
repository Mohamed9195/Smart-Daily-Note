//
//  ChildFolder.swift
//  SaveAny
//
//  Created by mohamed hashem on 11/29/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import Foundation
import RealmSwift

class ChildFolder: Object {
    
    @objc dynamic var Title: String = ""
    @objc dynamic var Create_Date: Date = Date()
    @objc dynamic var Info : String = ""
    var parentFolder = LinkingObjects(fromType: Folder.self, property: "childfolder")
    
}
