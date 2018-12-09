//
//  FolderCell.swift
//  SaveAny
//
//  Created by mohamed hashem on 11/29/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit

protocol deleteCellFolder {
    func delete(cell: FolderCell)
}

class FolderCell: UICollectionViewCell {
    
    var delegte: deleteCellFolder?
    @IBOutlet weak var numberItem: UILabel!
    @IBOutlet weak var namecell: UILabel!
    @IBOutlet weak var DeleteButton: UIButton! 
    
   

    
//    var isEditings: Bool = false{
//        didSet{
//           DeleteButton.isHidden = !DeleteButton.isHidden
//        }
//    }
//
    @IBAction func WhenDelte(_ sender: Any) {
       delegte?.delete(cell: self)
    }
}
