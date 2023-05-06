//
//  StorageItemsTableViewCell.swift
//  RestaurantManager_DATN
//
//  Created by Pham Tuan Anh on 09/04/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import UIKit

class StorageItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var lbStuffName: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var lbCreatedDate: UILabel!
    
    func configView(data: PhieuNhap) {
        let attributedString = NSMutableAttributedString(string: data.maphieu + "\n" + data.tenvatpham)
        let paragrapthStyle = NSMutableParagraphStyle()
        paragrapthStyle.lineSpacing = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragrapthStyle, range: NSRange(location: 0, length: attributedString.length))
        lbStuffName.attributedText = attributedString
        lbAmount.text = "\(data.soluong.clean) \(data.donvi)"
//        lbCreatedDate.text = data.ngaytao?.convertToString(withDateFormat: "dd-MM-yyyy")
        lbCreatedDate.text = data.creatorStaff?.tennhanvien
    }
    
    func configView(data: PhieuXuat, of data2: PhieuNhap?) {
//        lbStuffName.text =
        let attributedString = NSMutableAttributedString(string: (data2?.maphieu ?? "") + "\n" + (data2?.tenvatpham ?? ""))
        let paragrapthStyle = NSMutableParagraphStyle()
        paragrapthStyle.lineSpacing = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragrapthStyle, range: NSRange(location: 0, length: attributedString.length))
        lbStuffName.attributedText = attributedString
        lbAmount.text = "\(data.soluong.clean) \(data2?.donvi ?? "")"
//        lbCreatedDate.text = data.ngaytao?.convertToString(withDateFormat: "dd-MM-yyyy")
        lbCreatedDate.text = data.creatorStaff?.tennhanvien
    }
}
