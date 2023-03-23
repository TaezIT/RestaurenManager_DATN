//
//  Bill.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 19/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation
import ObjectMapper

struct BillModel: Decodable, Mappable {
    var billId: String! = UUID().uuidString
    var didPay: Int? = 0
    var foodTableId: String? = ""
    var staffid: String? = ""
    var timeCreate: Date = Date()
    var didDelete: Int? = 0
    var orderList: [Orders]?
    var staff: Staff?
    
    init?(map: Map) {
    }
    
    func isBillServed() -> Bool? {
        if let orderList = orderList {
            for order in orderList {
                if order.status < 0 || order.status < 3 {
                    return false
                }
            }
            return true
        }
        return nil
    }
    
    mutating func mapping(map: Map) {
        billId <- map["idhoadon"]
        didPay <- map["dathanhtoan"]
        foodTableId <- map["idbanan"]
        staffid <- map["idnhanvien"]
        var timestamp: Timestamp?
        timestamp <- map["ngaytao"]
        timeCreate = timestamp?.dateValue().getDateFormatted() ?? Date()
        didDelete <- map["daxoa"]
    }
}
