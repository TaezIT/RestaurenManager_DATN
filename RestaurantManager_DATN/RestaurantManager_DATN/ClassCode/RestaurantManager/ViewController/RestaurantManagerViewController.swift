//
//  RestaurantManagerViewController.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 16/03/2023.
//  Copyright © 2023 Hoang Dinh Huy. All rights reserved.
//

import UIKit

class RestaurantManagerViewController: UIViewController {
    
    //MARK: -Outlets
    @IBOutlet weak var btnHistory: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: -Properties
    var tableData: [BanAn] = []
    var currentTableData: [BanAn] = []
    var currentBillData: [HoaDon] = []
    private lazy var tableRefreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        return refresh
    } ()
    
    //MARK: -Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: -Action
    @IBAction func didTapHistory(_ sender: Any) {
        
    }
    
    //MARK: -Objc func
    @objc func fetchData() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        var isTableLoaded = false
        var isBillLoaded = false
        
        BanAn.fetchAllDataAvailable { [weak self] (data, error) in
            if error != nil {
                print(error.debugDescription)
            } else if let data = data {
                self?.tableData = data
            }
            isTableLoaded = true
            if isBillLoaded {
                self?.setupData()
            }
            
        }
    }
    
    //MARK: -Other func
    func setupData() {
        tableRefreshControl.endRefreshing()
        
        for (index, table)in tableData.enumerated() {
            for bill in currentBillData {
                if bill.idbanan == table.idbanan {
                    tableData[index].bill = bill
                }
            }
        }
        currentTableData = tableData
        self.collectionView.reloadData()
    }
}
