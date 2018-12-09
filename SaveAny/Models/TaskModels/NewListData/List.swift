//
//  List.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/2/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import Foundation
import RealmSwift

class ListItem : Object{
    
    @objc dynamic var ListTitle : String = ""
    @objc dynamic var ListDate : Date = Date()
    @objc dynamic var Status: Bool = false
    var Connection = LinkingObjects(fromType: CategoryList.self, property: "ParentList")
    
}
