//
//  BillManagerViewController.swift
//  RestaurantManager_DATN
//
//  Created by Pham Tuan Anh on 14/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import UIKit

class BillManagerViewController: UIViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var lbTotalBill: UILabel!
    @IBOutlet weak var txtStaff: UITextField!
    @IBOutlet weak var txtTable: UITextField!
    @IBOutlet weak var txtCreatedDate: DatePickerTextField!
    @IBOutlet weak var swPaid: UISwitch!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnAddNew: UIButton!
    
    weak var delegate: ManagerDataViewController?
    
    var forBillHistory: Bool = false
    
    var bill: HoaDon?
    var table: BanAn? {
        didSet {
            if table != nil {
                btnAddNew.isEnabled = true
            } else {
                btnAddNew.isEnabled = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addEndEditingTapGuesture()
        btnAddNew.setTitleColor(.lightGray, for: .disabled)
        txtCreatedDate.isDatePickerTextField(maximumDate: Date(), dateFormat: "dd-MM-yyyy hh:MM:ss")
        
        orderTableView.delegate = self
        orderTableView.dataSource = self
        
        orderTableView.register(UINib(nibName: "OrderManagerViewCell", bundle: nil), forCellReuseIdentifier: "OrderManagerViewCell")
        setupData()
        fetchTableData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.fetchData()
    }
    
    func fetchTableData() {
        if bill?.idbanan?.isEmpty ?? true {
            btnAddNew.isEnabled = false
        }
        if bill != nil {
            lbTitle.text = "Thay đổi hóa đơn"
            if forBillHistory {
                lbTitle.text = "Thông tin hóa đơn"
                btnDelete.isHidden = true
                btnConfirm.isHidden = true
                btnAddNew.isHidden = true
                txtStaff.isEnabled = false
                txtTable.isEnabled = false
                txtCreatedDate.isEnabled = false
                swPaid.isEnabled = false
                
                txtStaff.isDividerHidden = true
                txtTable.isDividerHidden = true
                txtCreatedDate.isDividerHidden = true
            }
            if bill?.daxoa == 1 {
                btnDelete.setTitle("Khôi phục", for: .normal)
            }
        } else {
//            btnDelete.backgroundColor = .gray
            bill = HoaDon()
            btnDelete.setTitle("Hủy", for: .normal)
        }
        if let id = bill?.idbanan, id.isEmpty == false {
            BanAn.fetchData(ofID: id) { [weak self] banan, error in
                if let banan = banan {
                    self?.table = banan
                    self?.txtTable.text = banan.sobanan
                }
            }
        }
    }
    
    func fetchBillData() {
        self.fetchTableData()
    }
    
    func setupData() {
        orderTableView.reloadData()
        lbTotalBill.text = "Tổng hóa đơn: " + (bill?.getTotalPayment().splittedByThousandUnits() ?? "0")
        txtStaff.text = bill?.staff?.tennhanvien
        txtCreatedDate.text = bill?.ngaytao.convertToString(withDateFormat: "dd-MM-yyyy hh:MM:ss")
        swPaid.isOn = bill?.dathanhtoan == 1 ? true : false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(txtTableTapped))
        txtTable.addGestureRecognizer(tapGesture)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(txtStaffTapped))
        txtStaff.addGestureRecognizer(tapGesture2)
    }
    
    @objc private func txtTableTapped() {
        let presentHandler = PresentHandler()
        presentHandler.presentManagerDataVC(self, manageType: .table, isForPickData: true)
    }
    
    @objc private func txtStaffTapped() {
        let presentHandler = PresentHandler()
        presentHandler.presentStaffManagerDataVC(self, manageType: .staff, isForPickData: true)
    }
    
    @IBAction func btnAddOrderTapped(_ sender: Any) {
        let present = PresentHandler()
        table?.bill = bill
        present.presentMakeOrderVC(self, tableData: table)
    }
    
    @IBAction func swPaidChanged(_ sender: UISwitch) {
        if sender.isOn == false {
            txtStaff.text = ""
            bill?.idnhanvien = ""
            if bill?.orderList?.isEmpty == false {
                for index in 0..<(bill?.orderList?.count ?? 1) {
                    bill?.orderList?[index].trangthai = 0
                }
                orderTableView.reloadData()
            }
        } else {
            if bill?.orderList?.isEmpty == false {
                for index in 0..<(bill?.orderList?.count ?? 1) {
                    bill?.orderList?[index].trangthai = 3
                }
                orderTableView.reloadData()
            }
        }
    }
    
    @IBAction func btnConfirmWasTapped(_ sender: Any) {
        
        bill?.dathanhtoan = swPaid.isOn ? 1 : 0
        if bill?.dathanhtoan == 1, bill?.idnhanvien == ""{
            self.showAlert(title: "Thiếu dữ liệu", message: "Vui lòng chọn nhân viên đã thanh toán hóa đơn") {
            }
            return
        }
        if bill?.dathanhtoan == 1, txtCreatedDate.text?.isEmpty == true {
            self.showAlert(title: "Thiếu dữ liệu", message: "Vui lòng chọn ngày tạo hóa đơn") {
                self.txtCreatedDate.becomeFirstResponder()
            }
            return
        }
        if let text = txtCreatedDate.text, let date = Date.getDate(fromString: text, withDateFormat: "dd-MM-yyyy hh:MM:ss") {
            bill?.ngaytao = date
            if bill?.orderList?.isEmpty == false {
                for index in 0..<(bill?.orderList?.count ?? 1) {
                    bill?.orderList?[index].ngaytao = date
                }
            }
        }
        let db = Firestore.firestore()
        
        if let bill = bill {
            Order.fetchAllData(ofBill: bill) { [weak self] (datas, error) in
                if let datas = datas, datas.isEmpty == false {
                    for item in datas {
                        db.collection("Order").document(item.idorder).delete()
                        
                        self?.table?.bill = bill
                        
                        if let table = self?.table {
                            
                            HoaDon.checkOutBill(forTable: table) { [weak self] err in
                                guard let strongSelf = self else { return }
                                if err != nil {
                                    print("CartViewController: Error Checking out Bill \(String(describing: strongSelf.bill?.idhoadon)) \(err!.localizedDescription)")
                                }
                                self?.dismiss(animated: true)
                            }
                        }
                    }
                } else {
                    self?.table?.bill = bill
                    
                    if let table = self?.table {
                        
                        HoaDon.checkOutBill(forTable: table) { [weak self] err in
                            guard let strongSelf = self else { return }
                            if err != nil {
                                print("CartViewController: Error Checking out Bill \(String(describing: strongSelf.bill?.idhoadon)) \(err!.localizedDescription)")
                            }
                            self?.dismiss(animated: true)
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func btnDeleteTapped(_ sender: Any) {
        if btnDelete.titleLabel?.text == "Hủy" {
            self.dismiss(animated: true)
            return
        }
        let db = Firestore.firestore()
        let will = bill?.daxoa == 0 ? 1 : 0
        let message = will == 0 ? "Bạn có chắc chắn muốn khôi phục dữ liệu không" : "Bạn có chắc chắn muốn xóa dữ liệu không"
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        let xacnhan = UIAlertAction(title: "Xác nhận", style: .default) { (_) in
            db.collection("HoaDon").document(self.bill!.idhoadon!).updateData(["daxoa": will])
            for order in self.bill?.orderList ?? [] {
                db.collection("Order").document(order.idorder).updateData(["daxoa": will])
            }
            self.dismiss(animated: true)
        }
        let huy = UIAlertAction(title: "Hủy", style: .cancel)
        alert.addAction(xacnhan)
        alert.addAction(huy)
        self.present(alert, animated: true)
    }
    
    @IBAction func btnBackWasTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }

}

extension BillManagerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bill?.orderList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderManagerViewCell", for: indexPath) as? OrderManagerViewCell else {
            fatalError("MakeOrderViewController: Can't dequeue for DishTableViewCell")
        }
        cell.order = bill?.orderList?[indexPath.item]
        
        return cell
    }
    
    
}

extension BillManagerViewController: ManagerPickedData {
    func dataWasPicked(data: Any) {
        if let data = data as? BanAn {
            txtTable.text = data.sobanan
            table = data
            bill?.idbanan = data.idbanan
            table?.bill = bill
        }
        
        if let data = data as? NhanVien {
            txtStaff.text = data.tennhanvien
            bill?.idnhanvien = data.idnhanvien
        }
    }
    
}

extension BillManagerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if App.shared.staffInfo?.quyen != 1 {
            return nil
        }
        let xoa = UITableViewRowAction(style: .default, title: "Xóa") {(_, index) in
            self.bill?.orderList?.remove(at: indexPath.item)
            self.orderTableView.reloadData()
            self.lbTotalBill.text = "Tổng hóa đơn: " + (self.bill?.getTotalPayment().splittedByThousandUnits() ?? "0")
            
        }
        let sua = UITableViewRowAction(style: .normal, title: "Sửa") { (_, index) in
            let order = self.table?.bill?.orderList?[index.item]
            
            let alert = UIAlertController(title: order?.dish?.tenmonan, message: "Số lượng: ", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.keyboardType = .numberPad
            }
            alert.addAction(UIAlertAction(title: "Xác nhận", style: .default, handler: { (action) in
                guard let text = alert.textFields?.first?.text else { return }
                if let soluong = Int(text), soluong > 0 {
                    self.bill?.orderList?[index.item].soluong = soluong
                    self.orderTableView.reloadData()
                    self.lbTotalBill.text = "Tổng hóa đơn: " + (self.bill?.getTotalPayment().splittedByThousandUnits() ?? "0")
                } else {
                    let subAlert = UIAlertController(title: "Lỗi", message: "Hãy kiểm tra lại số lượng", preferredStyle: .alert)
                    subAlert.addAction(UIAlertAction(title: "Oke", style: .destructive, handler: nil))
                    self.present(subAlert, animated: true, completion: nil)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        return [xoa, sua]
    }
}
