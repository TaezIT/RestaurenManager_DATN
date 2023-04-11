//
//  ManagerDataTableViewCell.swift
//  RestaurantManager_DATN
//
//  Created by Pham Tuan Anh on 31/01/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import UIKit

class ManagerDataTableViewCell: UITableViewCell {

    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lb1.text = ""
        lb2.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
