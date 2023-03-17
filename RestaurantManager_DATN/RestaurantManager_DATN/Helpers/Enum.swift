//
//  Enum.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 17/03/2023.
//  Copyright © 2023 Hoang Dinh Huy. All rights reserved.
//

import Foundation
 
enum CartState {
    case expended
    case collapsed
}

enum TableState: Int {
    case empty
    case inUsed
    case waiting
}

enum ManageType: Int {
    case table = 0
    case bill
    case staff
    case dishCategory
    case dish
    case importBill
    case exportBill
    case report
}

enum ItemsValue : Int {
    case Restaurant = 0
    case Kitchen
    case Storage
    case Manager
    case FeatureMenu
}
