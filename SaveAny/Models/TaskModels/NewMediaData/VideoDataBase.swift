//
//  VideoMediaData.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/2/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import Foundation
import RealmSwift

class VideoDataBase: Object {
    
    @objc dynamic var CreateDate: Date = Date()
    @objc dynamic var Video: Data?
    @objc dynamic var Information: String = ""
    
}
