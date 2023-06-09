//
//  DishViewCell.swift
//  Firebase_demo
//
//  Created by Pham Tuan Anh on 23/04/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

final class MenuDishTableViewCell: UITableViewCell {

    @IBOutlet weak var dishProfileImage: UIImageView!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishPriceLabel: UILabel!
    @IBOutlet weak var dishUnitLabel: UILabel!
    @IBOutlet weak var swInMenu: UISwitch!
    
    weak var delegate: MenuViewController?
    
    var dish: MonAn!
    
    func configView(data: MonAn) {
        dish = data
        if let url = URL(string: data.diachianh) {
            dishProfileImage.kf.setImage(with: url)
        }
        dishNameLabel.text = data.tenmonan
        dishUnitLabel.text = data.donvimonan
        if data.dongia > 0 {
            dishPriceLabel.text = data.dongia.splittedByThousandUnits()
        }
        swInMenu.isOn = dish?.trongthucdon == 1
    }
    @IBAction func swInMenuChanged(_ sender: Any) {
        dish.trongthucdon = swInMenu.isOn ? 1 : 0
        dish.updateInMenu(forDish: dish) { [weak self] (err) in
            print(err ?? "")
            if err == nil {
                guard let strongSelf = self else { return }
                if let indexpath = self?.delegate?.dishTableView.indexPath(for: strongSelf) {
                    self?.delegate?.currentDishData[indexpath.section][indexpath.item] = strongSelf.dish
                    self?.delegate?.dishTableView.reloadData()
                }
            }
        }
    }
}
