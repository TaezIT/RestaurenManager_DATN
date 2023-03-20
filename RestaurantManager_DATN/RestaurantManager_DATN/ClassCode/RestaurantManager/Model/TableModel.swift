//
//  Table.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 19/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation
import ObjectMapper

struct TableModel: Decodable, Mappable {
    
    var tableId: String! = UUID().uuidString
    var numberOrdinalTable: String? = ""
    var numberOfChair: Int? = -1
    var didDelete: Int? = 0
    
    var bill: BillModel?
    
    static func == (lhs: TableModel, rhs: TableModel) -> Bool {
        return lhs.tableId == rhs.tableId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(tableId)
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        tableId <- map["idbanan"]
        numberOrdinalTable <- map["sobanan"]
        numberOfChair <- map["soluongghe"]
        didDelete <- map["daxoa"]
    }
}
