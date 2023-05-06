//
//  Double+.swift
//  RestaurantManager_DATN
//
//  Created by Pham Tuan Anh on 17/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

extension Double {
    func splittedByThousandUnits() -> String {
        if self < 1000 {
            return String(format: "%.f", self)
        }
        var result = String(format: "%.f", self)
        var index = 3
        for _ in 1...result.count/3 {
            result.insert(".", at: result.index(result.endIndex, offsetBy: -index))
            index += 4
            if index == result.count {
                break
            }
        }
        return result
    }
}
