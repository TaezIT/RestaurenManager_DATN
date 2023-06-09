//
//  ManagerDataViewController.swift
//  RestaurantManager_DATN
//
//  Created by Pham Tuan Anh on 25/04/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import UIKit

protocol ManagerPickedData: NSObject {
    func dataWasPicked(data: Any)
}

class ManagerDataViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var vColumnTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var btnAddNewData: UIButton!
    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var swShowDeletedData: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topConstaint: NSLayoutConstraint!
    
    private lazy var tableRefreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        return refresh
    } ()
    
    weak var delegate: ManagerPickedData?
    
    var managerType: ManageType?
    var isForPickData: Bool = false
    var checkSelectCashier = false
    
    private var tableData: [BanAn] = []
    private var billData: [[HoaDon]] = []
    private var orderData: [Order] = []
    private var dishData: [MonAn] = []
    private var dishCategoryData: [TheLoaiMonAn] = []
    private var staffData: [NhanVien] = []
    private var importBillData: [[PhieuNhap]] = []
    private var exportBillData: [[PhieuXuat]] = []
    private var reportData :[[BaoCao]] = []
    
    private var currentTableData: [BanAn] = []
    private var currentBillData: [[HoaDon]] = []
    private var currentOrderData: [Order] = []
    private var currentDishData: [MonAn] = []
    private var currentDishCategoryData: [TheLoaiMonAn] = []
    private var currentStaffData: [NhanVien] = []
    private var currentImportBillData: [[PhieuNhap]] = []
    private var currentExportBillData: [[PhieuXuat]] = []
    private var currentReportData :[[BaoCao]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        fetchData()
    }
    
    private func setupView() {
        
        lb1.text = ""
        lb2.text = ""
        lb3.text = ""
        
        var title = "Quản lý "
        
        if isForPickData {
            title = "Chọn "
            btnAddNewData.isHidden = true
        }
        switch managerType {
        case .bill:
            title += "hóa đơn"
            lb1.text = "Thu Ngân"
            lb2.text = "Tổng HĐ"
            lb3.text = "TG tạo"
        case .table:
            title += "bàn ăn"
            lb1.text = "Bàn số"
            lb3.text = "Số lượng ghế"
        case .staff:
            title += "nhân viên"
            lb1.text = "Tên NV"
            lb3.text = "Chức vụ"
        case .dishCategory:
            title += "thể loại món ăn"
            lb1.text = "Tên thể loại"
            lb3.text = "Trạng thái"
        case .dish:
            title += "món ăn"
            vColumnTitleHeight.constant = 0
        case .importBill:
            title += "hóa đơn nhập"
            lb1.text = "Tên VP"
            lb2.text = "Số lượng"
            lb2.textAlignment = .center
            lb3.text = "Người tạo"
        case .exportBill:
            title += "hóa đơn xuất"
            lb1.text = "Tên VP"
            lb2.text = "Số lượng"
            lb2.textAlignment = .center
            lb3.text = "Người tạo"
        case .report:
            title += "báo cáo"
            vColumnTitleHeight.constant = 0
        default: break
        }
        
        dataTableView.refreshControl = tableRefreshControl
        
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        
        lbTitle.text = title
        
        dataTableView.delegate = self
        dataTableView.dataSource = self
        
        dataTableView.register(UINib(nibName: "ManagerDataTableViewCell", bundle: nil), forCellReuseIdentifier: "ManagerDataTableViewCell")
        dataTableView.register(UINib(nibName: "StorageItemsTableViewCell", bundle: nil), forCellReuseIdentifier: "StorageItemsTableViewCell")
        
        dataTableView.register(UINib(nibName: "MenuDishTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuDishTableViewCell")
        dataTableView.register(UINib(nibName: "DishHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "DishHeaderTableViewCell")
//        dataTableView.register(UITableViewHeaderFooterView.self, forCellReuseIdentifier: "header")
        dataTableView.register(UINib(nibName: "BillTableViewCell", bundle: nil), forCellReuseIdentifier: "BillTableViewCell")
        dataTableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
    }
    
    @objc func fetchData() {
        switch managerType {
        case .bill:
            fetchBillData()
        case .table:
            fetchTableData()
        case .staff:
            fetchStaffData()
        case .dishCategory:
            fetchDishCategoryData()
        case .dish:
            fetchDishCategoryData()
            fetchDishData()
        case .importBill:
            fetchImportBillData()
        case .exportBill:
            fetchImportBillData()
            fetchExportBillData()
        case .report:
            fetchReportData()
        default: break
            
        }
        tableRefreshControl.endRefreshing()
        
    }
    
    private func fetchStaffData() {
        NhanVien.fetchAllData { [weak self] (data, error) in
            let data = data?.filter({ $0.quyen > 0 })
            if error != nil {
                print(error.debugDescription)
            } else if let data = data {
                self?.staffData.removeAll()
                if self?.checkSelectCashier == false {
                    self?.staffData = data
                } else {
                    var staffConvertData: [NhanVien] = []
                    for item in data {
                        if item.quyen == 0 || item.quyen == 1 || item.quyen == 2 {
                            staffConvertData.append(item)
                        }
                    }
                    self?.staffData = staffConvertData
                }
            }
            self?.setupData()
        }
    }
    
    private func fetchBillData() {
        HoaDon.fetchAllData { [weak self] (data, error) in
            
            if error != nil {
                print(error.debugDescription)
            } else if let data = data {
                self?.billData.removeAll()
                var date: String?
                var tempArray: [HoaDon] = []
                for item in data {
                    let itemDate = String(item.ngaytao.convertToString().dropLast(9))
                    if date != itemDate {
                        if tempArray.isEmpty == false {
                            self?.billData.append(tempArray)
                        }
                        tempArray.removeAll()
                        date = itemDate
                        tempArray.append(item)
                    } else {
                        tempArray.append(item)
                    }
                }
                self?.billData.append(tempArray)
            }
            self?.setupData()
        }
    }
    
    private func fetchDishData() {
        MonAn.fetchAllData { [weak self] (data, error) in
            
            if error != nil {
                print(error.debugDescription)
            } else if let data = data {
                self?.dishData.removeAll()
                self?.dishData = data
            }
            self?.setupData()
        }
    }
    
    private func fetchDishCategoryData() {
        TheLoaiMonAn.fetchAllData{ [weak self] (data, error) in
            
            if error != nil {
                print(error.debugDescription)
            } else if let data = data {
                self?.dishCategoryData.removeAll()
                self?.dishCategoryData = data
            }
            self?.setupData()
        }
    }
    
    private func fetchTableData() {
        BanAn.fetchAllData { [weak self] (data, error) in
            
            if error != nil {
                print(error.debugDescription)
            } else if let data = data {
                self?.tableData.removeAll()
                self?.tableData = data
            }
            self?.setupData()
        }
    }
    
    private func fetchImportBillData() {
        PhieuNhap.fetchAllData { [weak self] (data, error) in
            if error != nil {
                print(error.debugDescription)
            } else if let data = data {
                self?.importBillData.removeAll()
                let data = data.sorted {
                    $0.ngaytao ?? Date() > $1.ngaytao ?? Date()
                }
                var date: String?
                var tempArray: [PhieuNhap] = []
                for item in data {
                    let itemDate = String(item.ngaytao?.convertToString(withDateFormat: "dd-MM-yyyy") ?? "")
                    if date != itemDate {
                        if tempArray.isEmpty == false {
                            self?.importBillData.append(tempArray)
                        }
                        tempArray.removeAll()
                        date = itemDate
                        tempArray.append(item)
                    } else {
                        tempArray.append(item)
                    }
                }
                self?.importBillData.append(tempArray)
            }
            self?.setupData()
        }
    }
    
    private func fetchExportBillData() {
        PhieuXuat.fetchAllData { [weak self] (data, error) in
            if error != nil {
                print(error.debugDescription)
            } else if let data = data {
                self?.exportBillData.removeAll()
                let data = data.sorted {
                    $0.ngaytao ?? Date() > $1.ngaytao ?? Date()
                }
                var date: String?
                var tempArray: [PhieuXuat] = []
                for item in data {
                    let itemDate = String(item.ngaytao?.convertToString(withDateFormat: "dd-MM-yyyy") ?? "")
                    if date != itemDate {
                        if tempArray.isEmpty == false {
                            self?.exportBillData.append(tempArray)
                        }
                        tempArray.removeAll()
                        date = itemDate
                        tempArray.append(item)
                    } else {
                        tempArray.append(item)
                    }
                }
                self?.exportBillData.append(tempArray)
            }
            self?.setupData()
        }
    }
    
    func fetchReportData() {
        BaoCao.fetchAllData { [weak self] (data, error) in
            if error != nil {
                print(error.debugDescription)
            } else if let data = data {
                self?.reportData.removeAll()
                var date: String?
                var tempArray: [BaoCao] = []
                let data = data.sorted {
                    $0.ngaytao ?? Date() > $1.ngaytao ?? Date()
                }
                for item in data {
                    let itemDate = String(item.ngaytao?.convertToString(withDateFormat: "dd-MM-yyyy") ?? "")
                    if date != itemDate {
                        if tempArray.isEmpty == false {
                            self?.reportData.append(tempArray)
                        }
                        tempArray.removeAll()
                        date = itemDate
                        tempArray.append(item)
                    } else {
                        tempArray.append(item)
                    }
                }
                self?.reportData.append(tempArray)
            }
            self?.setupData()
        }
    }
    
    private func setupData() {
        switch managerType {
        case .bill:
            self.currentBillData.removeAll()
            for item in billData {
                if swShowDeletedData.selectedSegmentIndex == 0 {
                    currentBillData.append( item.filter { $0.daxoa == 0 })
                } else {
                    currentBillData.append( item.filter { $0.daxoa == 1 })
                }
            }
        case .table:
            self.currentTableData.removeAll()
            if swShowDeletedData.selectedSegmentIndex == 0 {
                currentTableData.append(contentsOf: tableData.filter { $0.daxoa == 0 })
            } else {
                currentTableData.append(contentsOf: tableData.filter { $0.daxoa == 1 })
            }
            
        case .staff:
            self.currentStaffData.removeAll()
            if swShowDeletedData.selectedSegmentIndex == 0 {
                currentStaffData.append(contentsOf: staffData.filter { $0.daxoa == 0 })
            } else {
                currentStaffData.append(contentsOf: staffData.filter { $0.daxoa == 1 })
            }
            
        case .dishCategory:
            self.currentDishCategoryData.removeAll()
            if swShowDeletedData.selectedSegmentIndex == 0 {
                currentDishCategoryData.append(contentsOf: dishCategoryData.filter { $0.daxoa == 0 })
            } else {
                currentDishCategoryData.append(contentsOf: dishCategoryData.filter { $0.daxoa == 1 })
            }
        case .dish:
            self.currentDishData.removeAll()
            if swShowDeletedData.selectedSegmentIndex == 0 {
                currentDishData.append(contentsOf: dishData.filter { $0.daxoa == 0 })
            } else {
                currentDishData.append(contentsOf: dishData.filter { $0.daxoa == 1 })
            }
            self.currentDishCategoryData.removeAll()
            if swShowDeletedData.selectedSegmentIndex == 0 {
                currentDishCategoryData.append(contentsOf: dishCategoryData.filter { $0.daxoa == 0 })
            } else {
                currentDishCategoryData.append(contentsOf: dishCategoryData.filter { $0.daxoa == 1 })
            }
        case .importBill:
            self.currentImportBillData.removeAll()
            for item in importBillData {
                if swShowDeletedData.selectedSegmentIndex == 0 {
                    currentImportBillData.append( item.filter { $0.daxoa == 0 })
                } else {
                    currentImportBillData.append( item.filter { $0.daxoa == 1 })
                }
            }
        case .exportBill:
            self.currentExportBillData.removeAll()
            for item in exportBillData {
                if swShowDeletedData.selectedSegmentIndex == 0 {
                    currentExportBillData.append( item.filter { $0.daxoa == 0 })
                } else {
                    currentExportBillData.append( item.filter { $0.daxoa == 1 })
                }
            }
            self.currentImportBillData.removeAll()
            for item in importBillData {
                if swShowDeletedData.selectedSegmentIndex == 0 {
                    currentImportBillData.append( item.filter { $0.daxoa == 0 })
                } else {
                    currentImportBillData.append( item.filter { $0.daxoa == 1 })
                }
            }
        case .report:
            self.currentReportData.removeAll()
            for item in reportData {
                if swShowDeletedData.selectedSegmentIndex == 0 {
                    currentReportData.append( item.filter { $0.daxoa == 0 })
                } else {
                    currentReportData.append( item.filter { $0.daxoa == 1 })
                }
            }
        default: break
        }
        dataTableView.reloadData()
    }
    
    @IBAction func swChanged(_ sender: Any) {
        setupData()
    }
    
    @IBAction func btnAddNewDataWasTapped(_ sender: Any) {
        let presentHandler = PresentHandler()
        switch managerType {
        case .bill:
            presentHandler.presentBillManagerVC(self)
        case .table:
            presentHandler.presentTableManagerVC(self)
        case .staff:
            presentHandler.presentAddStaffManagerVC(self)
        case .dishCategory:
            presentHandler.presentDishCategoryManagerVC(self)
        case .dish:
            presentHandler.presentDishManagerVC(self)
        case .importBill:
            presentHandler.presentImportBillManagerVC(self)
        case .exportBill:
            presentHandler.presentExportBillManagerVC(self)
        default: break
        }
        
    }
    
    @IBAction func btnSearchTapped(_ sender: Any) {
        if managerType == .bill {
            let presentHandler = PresentHandler()
            presentHandler.presentSearchBillManagerVC(self, bills: billData)
            return
        }
        dataTableView.refreshControl = nil
        topConstaint.constant = 44
        searchBar.becomeFirstResponder()
    }
    @IBAction func btnBackWasTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension ManagerDataViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if managerType == .bill {
            return currentBillData.count
        }
        if managerType == .importBill {
            return currentImportBillData.count
        }
        if managerType == .exportBill {
            return currentExportBillData.count
        }
        if managerType == .dish {
            return currentDishCategoryData.count
        }
        if managerType == .report {
            return currentReportData.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch managerType {
        case .bill:
            return currentBillData[section].count
        case .table:
            return currentTableData.count
        case .staff:
            return currentStaffData.count
        case .dishCategory:
            return currentDishCategoryData.count
        case .dish:
            return currentDishData.filter { $0.idtheloaimonan == currentDishCategoryData[section].idtheloaimonan }.count
//            return currentDishData.count÷
        case .importBill:
            return currentImportBillData[section].count
        case .exportBill:
            return currentExportBillData[section].count
        case .report:
            return currentReportData[section].count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if managerType == .bill {
            if currentBillData[section].isEmpty == true {
                return nil
            }
            let title = String(currentBillData[section].first?.ngaytao.convertToString(withDateFormat: "dd-MM-yyyy") ?? "")
            return title.isEmpty ? nil : "   Ngày " + title
        }
        if managerType == .importBill {
            if currentImportBillData[section].isEmpty == true {
                return nil
            }
            let title = String(currentImportBillData[section].first?.ngaytao?.convertToString(withDateFormat: "dd-MM-yyyy") ?? "")
            return title.isEmpty ? nil : "   Ngày " + title
        }
        if managerType == .exportBill {
            if currentExportBillData[section].isEmpty == true {
                return nil
            }
            let title = String(currentExportBillData[section].first?.ngaytao?.convertToString(withDateFormat: "dd-MM-yyyy") ?? "")
            return title.isEmpty ? nil : "   Ngày " + title
        }
        if managerType == .report {
            if currentReportData[section].isEmpty == true {
                return nil
            }
            let title = String(currentReportData[section].first?.ngaytao?.convertToString(withDateFormat: "dd-MM-yyyy") ?? "")
            return title.isEmpty ? nil : "     Ngày " + title
        }
        if managerType == .dish {
            if currentDishData.filter({ $0.idtheloaimonan == currentDishCategoryData[section].idtheloaimonan }).isEmpty == true {
                return nil
            }
            return "    " + currentDishCategoryData[section].tentheloaimonan
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch managerType {
        case .bill:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BillTableViewCell", for: indexPath) as? BillTableViewCell else { fatalError("") }
            cell.bill = currentBillData[indexPath.section][indexPath.item]
            return cell
        case .table:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ManagerDataTableViewCell", for: indexPath) as? ManagerDataTableViewCell else { fatalError("") }
            let table = currentTableData[indexPath.item]
            cell.lb1.text = "Bàn \(table.sobanan ?? "")"
            cell.lb2.text = "\(table.soluongghe ?? 0) ghế"
            return cell
        case .staff:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ManagerDataTableViewCell", for: indexPath) as? ManagerDataTableViewCell else { fatalError("") }
            cell.lb1.text = currentStaffData[indexPath.item].tennhanvien
            cell.lb2.text = currentStaffData[indexPath.item].getPosition()
            return cell
        case .dishCategory:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ManagerDataTableViewCell", for: indexPath) as? ManagerDataTableViewCell else { fatalError("") }
            cell.lb1.text = currentDishCategoryData[indexPath.item].tentheloaimonan
            cell.lb2.text = currentDishCategoryData[indexPath.item].daxoa == 0 ? "Khả dụng" : "Đã xoá"
            return cell
        case .dish:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuDishTableViewCell", for: indexPath) as? MenuDishTableViewCell else { fatalError("") }
            let listDish = currentDishData.filter { $0.idtheloaimonan == currentDishCategoryData[indexPath.section].idtheloaimonan }
            cell.configView(data: listDish[indexPath.item])
            return cell
        case .importBill:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StorageItemsTableViewCell", for: indexPath) as? StorageItemsTableViewCell else { fatalError("") }
            cell.configView(data: currentImportBillData[indexPath.section][indexPath.item])
            return cell
        case .exportBill:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StorageItemsTableViewCell", for: indexPath) as? StorageItemsTableViewCell else { fatalError("") }
            var importBill: PhieuNhap? = nil
            
            for list in importBillData {
                importBill = list.filter {$0.idphieunhap == currentExportBillData[indexPath.section][indexPath.item].idphieunhap }.first
                if importBill != nil {
                    break
                }
            }
            cell.configView(data: currentExportBillData[indexPath.section][indexPath.item], of: importBill)
            return cell
        case .report:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") else { fatalError("") }
            cell.textLabel?.text = currentReportData[indexPath.section][indexPath.item].tieude
            return cell
        default: break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if managerType == .dish {
            return 100
        }
        return UITableView.automaticDimension
    }
}

extension ManagerDataViewController: UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isForPickData {
            var pickedData: Any?
            switch managerType {
            case .bill:
                pickedData = currentBillData[indexPath.item]
            case .table:
                pickedData = currentTableData[indexPath.item]
            case .staff:
                pickedData = currentStaffData[indexPath.item]
            case .dishCategory:
                pickedData = currentDishCategoryData[indexPath.item]
            case .dish:
                let listDish = currentDishData.filter { $0.idtheloaimonan == currentDishCategoryData[indexPath.section].idtheloaimonan }
                pickedData = listDish[indexPath.item]
            case .importBill:
                pickedData = currentImportBillData[indexPath.section][indexPath.item]
            case .exportBill:
                pickedData = currentExportBillData[indexPath.section][indexPath.item]
            case .report:
                pickedData = currentReportData[indexPath.section][indexPath.item]
            default: return
            }
            if let pickedData = pickedData {
                delegate?.dataWasPicked(data: pickedData)
                self.dismiss(animated: true)
            }
            return
        }
        
        let presentHandler = PresentHandler()
        switch managerType {
        case .bill:
            presentHandler.presentBillManagerVC(self, bill: currentBillData[indexPath.section][indexPath.item])
        case .table:
            presentHandler.presentTableManagerVC(self, table: currentTableData[indexPath.item])
        case .staff:
            presentHandler.presentStaffManagerVC(self, staff: currentStaffData[indexPath.item])
        case .dishCategory:
            presentHandler.presentDishCategoryManagerVC(self, dishCategoryData: currentDishCategoryData[indexPath.item])
        case .dish:
            let listDish = currentDishData.filter { $0.idtheloaimonan == currentDishCategoryData[indexPath.section].idtheloaimonan }
            presentHandler.presentDishManagerVC(self, dishData: listDish[indexPath.item])
        case .importBill:
            presentHandler.presentImportBillManagerVC(self, data: currentImportBillData[indexPath.section][indexPath.item])
        case .exportBill:
            var importBill: PhieuNhap? = nil
            
            for list in importBillData {
                importBill = list.filter {$0.idphieunhap == currentExportBillData[indexPath.section][indexPath.item].idphieunhap }.first
                if importBill != nil {
                    break
                }
            }
            presentHandler.presentExportBillManagerVC(self, data: currentExportBillData[indexPath.section][indexPath.item], imp: importBill)
        case .report:
            presentHandler.presentReportDetailsVC(self, data: currentReportData[indexPath.section][indexPath.item])
        default: break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

extension ManagerDataViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dataTableView.refreshControl = tableRefreshControl
        searchBar.endEditing(true)
        topConstaint.constant = 0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var searchText = searchText.lowercased().trimmed
        switch managerType {
        case .bill:
            break
        case .table:
            if let _ = searchText.lowercased().range(of: "bàn") {
                searchText = searchText.replacingOccurrences(of: "bàn", with: "")
            } else if let  _ = searchText.lowercased().range(of: "ban") {
                searchText = searchText.replacingOccurrences(of: "ban", with: "")
            }
 
            if searchText.isEmpty == true {
                currentTableData = tableData
                break
            }
            let result = tableData.filter({ $0.sobanan?.contains(searchText) ?? false })
            currentTableData = result
        case .staff:
            if searchText.isEmpty == true {
                currentStaffData = staffData
                break
            }
            let result = staffData.filter({ $0.tennhanvien.lowercased().contains(searchText) })
            currentStaffData = result
        case .dishCategory:
            if searchText.isEmpty == true {
                currentDishCategoryData = dishCategoryData
                break
            }
            let result = dishCategoryData.filter({ $0.tentheloaimonan.lowercased().contains(searchText) })
            currentDishCategoryData = result
        case .dish:
            if searchText.isEmpty == true {
                currentDishData = dishData
                break
            }
            let dishCategoryList = dishCategoryData.filter({ $0.tentheloaimonan.lowercased().contains(searchText)})
            let result = dishData.filter({
                let currentItem = $0
                return ($0.tenmonan.lowercased().contains(searchText) || dishCategoryList.filter({ $0.idtheloaimonan == currentItem.idtheloaimonan }).isEmpty == false) })
            currentDishData = result
        case .importBill:
            if searchText.isEmpty == true {
                currentImportBillData = importBillData
                break
            }
            let text = searchText
            currentImportBillData.removeAll()
            for item in importBillData {
                let list = item.filter({$0.tenvatpham.lowercased().contains(text) || $0.ngaytao?.convertToString(withDateFormat: "dd-MM-yyyy").lowercased().contains(text) ?? false || $0.maphieu.lowercased().contains(text) || $0.creatorStaff?.tennhanvien.lowercased().contains(text) ?? false})
                if list.isEmpty == false {
                    currentImportBillData.append(list)
                }
            }
        case .exportBill:
            if searchText.isEmpty == true {
                currentExportBillData = exportBillData
                break
            }
            let text = searchText
            currentExportBillData.removeAll()
            for item in exportBillData {
                
                let list = item.filter({
                    let currentItem = $0
                    var imp: PhieuNhap?
                    for item in currentImportBillData {
                        imp = item.first { $0.idphieunhap == currentItem.idphieunhap}
                        if imp != nil {
                            break
                        }
                    }
                    return (imp?.tenvatpham.lowercased().contains(text) ?? false || $0.ngaytao?.convertToString(withDateFormat: "dd-MM-yyyy").lowercased().contains(text) ?? false || imp?.maphieu.lowercased().contains(text) ?? false || $0.creatorStaff?.tennhanvien.lowercased().contains(text) ?? false)})
                if list.isEmpty == false {
                    currentExportBillData.append(list)
                }
            }
        case .report:
            if searchText.isEmpty == true {
                currentReportData = reportData
                break
            }
            currentReportData.removeAll()
            for list in reportData {
                let temp = list.filter({ $0.tieude.lowercased().contains(searchText)})
                if temp.isEmpty == false {
                    currentReportData.append(temp)
                }
            }
        default: break
        }
        dataTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
