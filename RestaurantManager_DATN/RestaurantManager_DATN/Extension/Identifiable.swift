//
//  Identifiable.swift
//  Soha
//
//  Created by Truong Thang on 24/11/2022.
//  Copyright © 2022 Le Duc Anh. All rights reserved.
//

import Foundation
import UIKit

typealias Identifiable = ClassIdentifiable & NibIdentifiable

protocol ClassIdentifiable: AnyObject {
    static var identifier: String { get }
}

extension ClassIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

protocol NibIdentifiable: AnyObject {
    static var nib: UINib { get }
}

extension NibIdentifiable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

extension UIView: Identifiable {}
