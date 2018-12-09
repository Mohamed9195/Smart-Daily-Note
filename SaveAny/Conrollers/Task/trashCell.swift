//
//  trashCell.swift
//  SaveAny
//
//  Created by mohamed hashem on 11/30/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit

class trashCell: UITableViewCell {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var trashCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
