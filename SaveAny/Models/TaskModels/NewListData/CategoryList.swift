//
//  CategoryList.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/2/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryList : Object{
    
    @objc dynamic var ListTitle : String = ""
    @objc dynamic var ListDate : Date = Date()
    let ParentList = List<ListItem>()
    
   
}
