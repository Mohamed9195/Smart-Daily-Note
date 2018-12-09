//
//  NewsTableViewCell.swift
//  SaveAny
//
//  Created by mohamed hashem on 12/7/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var lablecontent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
