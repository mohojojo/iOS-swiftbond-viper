//
//  TextTableViewCell.swift
//  reactiveKitBond
//
//  Created by Mogyoródi Balázs on 2017. 05. 02..
//  Copyright © 2017. Mogyoródi Balázs. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    @IBOutlet weak var cellText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
