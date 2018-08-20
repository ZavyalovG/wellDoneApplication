//
//  EventModelTableViewCell.swift
//  wellDoneApp
//
//  Created by Глеб Завьялов on 16/08/2018.
//  Copyright © 2018 Глеб Завьялов. All rights reserved.
//

import UIKit

class EventModelTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageViewIndic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
