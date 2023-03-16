//
//  DishDetailsViewController.swift
//  RestaurantManager_DATN
//
//  Created by Pham Tuan Anh on 27/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import UIKit

class DishDetailsViewController: UIViewController {
    
//    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imvDish: UIImageView!
    @IBOutlet weak var lbDishName: UILabel!
    @IBOutlet weak var lbDishDescription: UILabel!
    @IBOutlet weak var lbDishSubtitle: UILabel!
    
    var dish: MonAn!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
    }
    
    func setupView() {
        if let url = URL(string: dish.diachianh) {
            imvDish.kf.setImage(with: url)
        }
        lbDishSubtitle.text = "\(dish.donvimonan) - \(dish.dongia.splittedByThousandUnits())"
        lbDishName.text = dish.tenmonan
        lbDishDescription.text = dish.motachitiet
    }
    
    @IBAction func btnBackWasTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
