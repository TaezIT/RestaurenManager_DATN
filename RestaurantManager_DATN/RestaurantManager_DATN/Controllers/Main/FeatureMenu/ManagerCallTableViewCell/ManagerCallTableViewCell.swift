//
//  ManagerCallTableViewCell.swift
//  RestaurantManager_DATN
//
//  Created by Pham Tuan Anh on 27/02/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import UIKit

class ManagerCallTableViewCell: UITableViewCell {

    @IBOutlet weak var lbDetail: UILabel!
    func configView(data: NhanVien) {
        lbDetail.text = "\(data.tennhanvien) - \(data.getPosition())"
    }
    
}
