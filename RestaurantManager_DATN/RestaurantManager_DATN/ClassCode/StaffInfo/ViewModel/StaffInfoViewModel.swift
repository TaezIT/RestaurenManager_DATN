//
//  StaffInfoViewModel.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 10/04/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation

class StaffInfoViewModel {
    func updateInfor(staffName: String, staffPhone: String, staffAddress: String,author: Int) {
        var staff = StaffModel()
        let db = Firestore.firestore()
        db.collection("NhanVien").document(staff?.staffId ?? "").updateData(["tennhanvien":staffName, "sodienthoai": staffPhone, "diachi": staffAddress, "quyen": author]) { [weak self] error in
            if error == nil {
                let supervc =  ManagerDataViewController()
                supervc.fetchData()
            }
        }
    }
}
