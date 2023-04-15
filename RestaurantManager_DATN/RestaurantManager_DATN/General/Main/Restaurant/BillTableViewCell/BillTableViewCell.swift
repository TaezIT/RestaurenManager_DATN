//
//  TakeawayBillTableViewCell.swift
//  RestaurantManager_DATN
//
//  Created by Pham Tuan Anh on 09/04/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTotalPay: UILabel!
    @IBOutlet weak var lbStaffName: UILabel!
    @IBOutlet weak var lbCreateTime: UILabel!
    
    var bill: HoaDon? {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        lbTotalPay.text = bill?.getTotalPayment().splittedByThousandUnits() ?? ""
        lbStaffName.text = bill?.staff?.tennhanvien ?? ""
        lbCreateTime.text = String(bill?.ngaytao.convertToString(withDateFormat: "hh:MM:ss") ?? "")
    }
    
}
