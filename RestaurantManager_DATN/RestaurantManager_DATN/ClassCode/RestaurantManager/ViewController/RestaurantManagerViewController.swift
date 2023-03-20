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
    var tableData: [TableModel] = []
    var currentTableData: [TableModel] = []
    var currentBillData: [BillModel] = []
    var isNotAuthored: Bool = true
    let restaurentManagerViewModel = RestaurentManagerViewModel()
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
        if App.shared.staffInfo?.quyen != 1 && App.shared.staffInfo?.quyen != 2 {
            return
        }
        let presenter = PresentHandler()
        presenter.presentBillHistoryVC(self)
    }
    
    //MARK: -Objc func
    @objc func fetchData() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        var isTableLoaded = false
        var isBillLoaded = false
        
        RestaurentManagerViewModel.fetchAllDataAvailable { [weak self] (data, error) in
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
                if bill.foodTableId == table.tableId {
                    tableData[index].bill = bill
                }
            }
        }
        currentTableData = tableData
        self.collectionView.reloadData()
    }
    
    func checkAuthor() {
        if App.shared.staffInfo?.quyen == 1 || App.shared.staffInfo?.quyen == 2 || App.shared.staffInfo?.quyen == 3 {
            isNotAuthored = false
        }
        if App.shared.staffInfo?.quyen != 1 && App.shared.staffInfo?.quyen != 2 {
            btnHistory.isEnabled = false
            btnHistory.tintColor = .lightGray
        }
    }
    deinit {
        logger()
    }
    
    func setUpViews() {
        checkAuthor()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerCellByNib(TableCollectionViewCell.self)
    }
}

extension RestaurantManagerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentTableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let minimumInteritemSpacing = layout?.minimumInteritemSpacing ?? 0.0
        let leftAndRightSectionInset = (layout?.sectionInset.left ?? 0) + (layout?.sectionInset.right ?? 0)
        
        let tableCellWidth = ((collectionView.frame.size.width - leftAndRightSectionInset - minimumInteritemSpacing * (3.0 - 1.0))/3.0).rounded(.towardZero)
        return CGSize(width: tableCellWidth, height: UIScreen.main.bounds.height/6)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(TableCollectionViewCell.self, forIndexPath: indexPath)
        cell.configViews(data: currentTableData[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if isNotAuthored {
//            return
//        }
//        let presentHandler = PresentHandler()
//        guard let cell = collectionView.cellForItem(at: indexPath) as? TableCollectionViewCell else { return }
//        if cell.state == .empty {
//            presentHandler.presentMakeOrderVC(self, tableData: currentTableData[indexPath.item])
//        } else {
//            presentHandler.presentTableBillDetailVC(self, table: currentTableData[indexPath.item])
//        }
    }
    
    
}
