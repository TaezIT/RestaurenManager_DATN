//
//  Orders.swift
//  RestaurantManager_DATN
//
//  Created by Tuấn Anh on 23/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation
import ObjectMapper

struct OrdersModel: Decodable, Mappable {
    
    var ordersId: String! = UUID().uuidString
    var billId: String? = ""
    var numberOfOrders: Int = 1
    var status: Int = 0
    var foodId: String? = ""
    var timeCreate: Date?
    var didDelete: Int? = 0
    var dish: FoodModel?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        ordersId <- map["idorder"]
        foodId <- map["idmonan"]
        billId <- map["idhoadon"]
        numberOfOrders <- map["soluong"]
        status <- map["trangthai"]
        var timestamp: Timestamp?
        timestamp <- map["ngaytao"]
        timeCreate = timestamp?.dateValue().getDateFormatted()
        didDelete <- map["daxoa"]
    }
    
    static func == (lhs: OrdersModel, rhs: OrdersModel) -> Bool {
        return lhs.ordersId == rhs.ordersId
    }
    
    func getState(forNextState: Bool = false) -> String {
        var trangthai = self.status
        if forNextState {
            trangthai += 1
        }
        switch trangthai {
        case 0:
            return "Đang chờ"
        case 1:
            return "Đang nấu"
        case 2:
            return "Đã nấu"
        case 3:
            return "Hoàn thành"
        default:
            return "nil"
        }
    }
    
}
