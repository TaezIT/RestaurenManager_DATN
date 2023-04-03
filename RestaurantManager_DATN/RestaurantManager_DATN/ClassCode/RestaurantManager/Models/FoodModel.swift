//
//  Food.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 19/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation
import ObjectMapper

struct FoodModel: Decodable, Mappable {
    
    init?(map: ObjectMapper.Map) {
    }
    
    var foodId: String! = UUID().uuidString
    var foodName: String? = ""
    var unit: String? = ""
    var unitPrice: Double? = 0
    var detail: String? = ""
    var placeImage: String? = ""
    var idKindOfFood: String? = ""
    var inBill: Int? = -1
    var didDelete: Int? = 0
    
    init?() {
    }
    
    mutating func mapping(map: Map) {
        foodId <- map["idmonan"]
        foodName <- map["tenmonan"]
        unit <- map["donvimonan"]
        unitPrice <- map["dongia"]
        detail <- map["motachitiet"]
        placeImage <- map["diachianh"]
        idKindOfFood <- map["idtheloaimonan"]
        inBill <- map["trongthucdon"]
        didDelete <- map["daxoa"]
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(foodId)
    }

    
    static func == (lhs: FoodModel, rhs: FoodModel) -> Bool {
        return lhs.foodId == rhs.foodId
    }
}
