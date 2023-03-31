//
//  OrderViewController.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 31/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {

    @IBOutlet weak var topConstantTableView: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintDishTableView: NSLayoutConstraint!
    @IBOutlet weak var dishTableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    weak var delegate: RestaurantManagerViewController?
    var table: TableModel?
    var dishData: [[FoodModel]] = []
    var currentDishData: [[FoodModel]] = []
    var dishCategoryData: [DishCategoryModel] = []
    var cartVisible: Bool = false
    var nextState: CartState {
        return cartVisible ? .collapsed : .expended
    }
    var visualEffectView: UIVisualEffectView!
    var startCartHeight: CGFloat = 0
    var endCartHeight: CGFloat = 0
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


 

}
