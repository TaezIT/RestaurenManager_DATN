//
//  DishHeaderViewCell.swift
//  
//
//  Created by Pham Tuan Anh on 23/10/2023.
//

import UIKit

final class DishHeaderViewCell: UITableViewCell {

    @IBOutlet weak var dishCategoryLabel: UILabel!
    
//    var dishCategory: DishCategoryModel! {
//        didSet {
//            setupView()
//        }
//    }
//    
    func setupView(text: String) {
        dishCategoryLabel.text = text
    }
}
