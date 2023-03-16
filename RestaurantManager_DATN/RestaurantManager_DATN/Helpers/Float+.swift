//
//  Float+.swift
//  RestaurantManager_DATN
//
//  Created by Pham Tuan Anh on 24/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
