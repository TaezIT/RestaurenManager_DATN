//
//  DishCategoryModel.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 31/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation
import ObjectMapper

struct DishCategoryModel: Decodable, Mappable {
    
    var idDishCategory: String! = UUID().uuidString
    var nameDishCategory: String = ""
    var didDelete: Int = 0
    
    init?(map: ObjectMapper.Map) {
    }
    
    init?() {
    }
    
    static func == (lhs: DishCategoryModel, rhs: DishCategoryModel) -> Bool {
        return lhs.idDishCategory == rhs.idDishCategory
    }
    
    mutating func mapping(map: Map) {
        idDishCategory <- map["idtheloaimonan"]
        nameDishCategory <- map["tentheloaimonan"]
        didDelete <- map["daxoa"]
    }
    
}
