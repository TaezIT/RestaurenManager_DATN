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

    deinit {
        logger()
    }
 
    private func setupViews() {
        addEndEditingTapGuesture()
        if let sobanan = table?.numberOrdinalTable {
            lblTitle.text = "Bàn " + sobanan
        }
        
        dishTableView.dataSource = self
        dishTableView.delegate = self
        dishTableView.registerCellByNib(DishHeaderViewCell.self)
        dishTableView.registerCellByNib(DishTableViewCell.self)
    }
}

extension OrderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if currentDishData[section].isEmpty == true {
            return 0
        }
        return 50.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dishCategoryData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDishData[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if currentDishData[section].isEmpty == true {
            return nil
        }
        
        let headerCell = tableView.dequeueCell(DishHeaderViewCell.self)
        headerCell.setupView(text: dishCategoryData[section].nameDishCategory)
        return headerCell
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(DishTableViewCell.self)
        var amount = 0
        for order in table?.bill?.orderList ?? [] {
            if order.foodId == currentDishData[indexPath.section][indexPath.item].foodId {
                amount = order.numberOfOrders
            }
        }
//        cell.configView(data: currentDishData[indexPath.section][indexPath.item], amount: amount)
//        cell.delegate = self
        return cell
    }
    
   
    
}
