//
//  ReportModel.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 05/04/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation
import ObjectMapper

struct ReportModel: Decodable, Mappable {
    var idReport: String! = UUID().uuidString
    var idStaff: String = ""
    var title: String = ""
    var content: String = ""
    var timeCreate: Date?
    var typeReport: Int = 0
    var didDelete: Int = 0
    var staff: StaffModel?

    init?() {
        
    }
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        idReport <- map["idbaocao"]
        idStaff <- map["idnhanvien"]
        title <- map["tieude"]
        var timestamp: Timestamp?
        timestamp <- map["ngaytao"]
        timeCreate = timestamp?.dateValue().getDateFormatted() ?? Date()
        content <- map["noidung"]
        typeReport <- map["loaibaocao"]
        didDelete <- map["daxoa"]
    }
}
