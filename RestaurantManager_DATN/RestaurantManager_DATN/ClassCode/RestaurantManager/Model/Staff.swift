//
//  Staff.swift
//  RestaurantManager_DATN
//
//  Created by Tuấn Anh on 23/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation
import ObjectMapper

struct Staff: Decodable, Mappable {
    var staffId: String! = UUID().uuidString
    var staffName: String = ""
    var phoneNumber: String = ""
    var email: String = ""
    var place: String = ""
    var authority: Int = -1
    var idLoginAccount: String = ""
    var didSelected: Int = 0
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        staffId <- map["idnhanvien"]
        staffName <- map["tennhanvien"]
        phoneNumber <- map["sodienthoai"]
        email <- map["email"]
        place <- map["diachi"]
        authority <- map["quyen"]
        idLoginAccount <- map["idtaikhoandangnhap"]
        didSelected <- map["daxoa"]
    }
    
    func getPosition() -> String {
        switch authority {
        case 0:
            return "Admin"
        case 1:
            return "Quản lý nhà hàng"
        case 2:
            return "Nhân viên thu ngân"
        case 3:
            return "Nhân viên phục vụ"
        case 4:
            return "Quản lý nhà bếp"
        case 5:
            return "Quản lý nhà kho"
        default:
            return "nil"
        }
    }
}
