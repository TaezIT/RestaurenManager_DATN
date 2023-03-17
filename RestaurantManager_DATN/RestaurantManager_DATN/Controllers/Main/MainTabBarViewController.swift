//
//  MainViewController.swift
//  RestaurantManager_DATN
//
//  Created by Pham Tuan Anh on 08/02/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if App.shared.staffInfo?.quyen != 1 {
            self.tabBar.items?[ItemsValue.Manager.rawValue].isEnabled = false
        }
        
        if App.shared.staffInfo?.quyen == 2 || App.shared.staffInfo?.quyen == 3 {
            self.tabBar.items?[ItemsValue.Storage.rawValue].isEnabled = false
        }
        
        if App.shared.staffInfo?.quyen == 5 {
            self.tabBar.items?[ItemsValue.Restaurant.rawValue].isEnabled = false
            self.tabBar.items?[ItemsValue.Kitchen.rawValue].isEnabled = false
            self.selectedIndex = ItemsValue.Storage.rawValue
        }
        if App.shared.staffInfo?.quyen == 4 {
            self.selectedIndex = ItemsValue.Kitchen.rawValue
        }
    }
    

}
