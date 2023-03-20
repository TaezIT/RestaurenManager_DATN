//
//  UIView-Ex.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 20/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    func takeSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        var image: UIImage?
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}
