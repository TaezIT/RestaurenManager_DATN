//
//  RestaurentManagerViewModel.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 19/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation

class RestaurentManagerViewModel {
    
    func fetchAllDataAvailable(completion: @escaping ([TableModel]?, Error?) -> Void) {
        var banans = [TableModel]()
        let db = Firestore.firestore()
        
        db.collection("BanAn").whereField("daxoa", isEqualTo: 0).order(by: "sobanan").getDocuments { (snapshot, err) in
            if err != nil {
                
                print("Error getting TableModel Data: \(err!.localizedDescription)")
                completion(nil, err)
                
            } else if snapshot != nil, !snapshot!.documents.isEmpty {
                
                snapshot!.documents.forEach({ (document) in
                    if let banan = TableModel(JSON: document.data()) {
                        banans.append(banan)
                    }
                })
                completion(banans, nil)
            } else {
                completion(banans, nil)
            }
        }
    }
    
    func fetchUnpaidBill(completion: @escaping ([BillModel]?, Error?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("HoaDon").whereField("daxoa", isEqualTo: 0).whereField("dathanhtoan", isEqualTo: 0).order(by: "ngaytao").getDocuments { (snapshot, err) in
            if err != nil {
                
                print("Error getting HoaDon Data: \(err!.localizedDescription)")
                completion(nil, err)
                
            } else if snapshot != nil, !snapshot!.documents.isEmpty {
                
                self.getAllReferanceData(of: snapshot!) { (bills, error) in
                    completion(bills, error)
                }
            } else {
                completion([], nil)
            }
        }
    }
    
    func fetchAllData(ofBill bill: BillModel ,
                      completion: @escaping ([OrdersModel]?, Error?) -> Void) {
        
        var datas = [OrdersModel]()
        let db = Firestore.firestore()
        
        db.collection("Order").whereField("idhoadon", isEqualTo: bill.billId!).getDocuments { (snapshot, err) in
            if err != nil {
                
                print("Error getting HoaDon Data: \(err!.localizedDescription)")
                completion(nil, err)
                
            } else if snapshot != nil, !snapshot!.documents.isEmpty {
                
                snapshot!.documents.forEach({ (document) in
                    if var order = OrdersModel(JSON: document.data()) {
                        self.fetchData(byOrder: order) { (dish, error) in
                            if let dish = dish {
                                order.dish = dish
                            }
                            datas.append(order)
                            if datas.count == snapshot?.documents.count {
                                completion(datas, nil)
                            }
                        }
                    }
                })
                
            } else {
                completion(datas, nil)
            }
        }
    }
    
    func fetchData(byOrder order: OrdersModel, completion: @escaping (FoodModel?, Error?) -> Void) {
        let db = Firestore.firestore()
        guard let idmonan = order.foodId else {
            return
        }
        db.collection("MonAn").document(idmonan).getDocument { (snapshot, err) in
            if err != nil {
                
                print("Error getting BanAn Data: \(err!.localizedDescription)")
                completion(nil, err)
                
            } else if let data = snapshot?.data() {
                
                let dish = FoodModel(JSON: data)
                
                completion(dish, nil)
            } else {
                completion(FoodModel(), nil)
            }
        }
    }
    
    func fetchData(forID id: String, completion: @escaping (StaffModel?, Error?) -> Void) {
        if id == "" {
            completion(nil,nil)
            return
        }
        var result = StaffModel()
        let db = Firestore.firestore()
        
        db.collection("NhanVien").document(id).getDocument { (snapshot, err) in
            if err != nil {
                
                print("Error getting BanAn Data: \(err!.localizedDescription)")
                completion(nil, err)
                
            } else if let data = snapshot?.data() {
                
                if let data = StaffModel(JSON: data) {
                    result = data
                }
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    
    
    
    func getAllReferanceData(of snapshot: QuerySnapshot, completion: @escaping ([BillModel]?, Error?) -> Void) {
        var bills = [BillModel]()
        snapshot.documents.forEach({ (document) in
            if var bill = BillModel(JSON: document.data()) {
                var orderLoaded = false
                var staffLoaded = false
                self.fetchAllData(ofBill: bill) { (datas, error) in
                    if let orders = datas {
                        bill.orderList = orders
                    }
                    orderLoaded = true
                    if staffLoaded {
                        bills.append(bill)
                    }
                    if bills.count == snapshot.documents.count {
                        completion(bills, nil)
                    }
                    
                    if error != nil {
                        completion(nil, error)
                    }
                }
                if let idnv = bill.staffid {
                    self.fetchData(forID: idnv) { (staff, error) in
                        bill.staff = staff
                        staffLoaded = true
                        if orderLoaded {
                            bills.append(bill)
                        }
                        if bills.count == snapshot.documents.count {
                            completion(bills, nil)
                        }
                        if error != nil {
                            completion(nil, error)
                        }
                    }
                } else {
                    staffLoaded = true
                    if orderLoaded {
                        bills.append(bill)
                    }
                    if bills.count == snapshot.documents.count {
                        completion(bills, nil)
                    }
                }
            }
        })
    }
}


