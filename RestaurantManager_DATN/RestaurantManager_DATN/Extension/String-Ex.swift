//
//  String-Ex.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 21/04/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation
import UIKit
extension String {
    
    func isValidEmail() -> Bool {
           let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
           return predicate.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
           let regex = "[A-Z0-9a-z!@#$%&*+ -=<>]{8,20}"
           let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
           return predicate.evaluate(with: self)
    }
    
    func isValidName() -> Bool {
              let regex = "[^a-z0-9A-Z_ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễếệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]/u"
              let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
              return predicate.evaluate(with: self)
       }
}
