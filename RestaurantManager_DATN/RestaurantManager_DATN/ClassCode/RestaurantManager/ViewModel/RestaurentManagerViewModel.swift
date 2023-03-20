//
//  RestaurentManagerViewModel.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 19/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation

class RestaurentManagerViewModel {
    
    static func fetchAllDataAvailable(completion: @escaping ([TableModel]?, Error?) -> Void) {
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

    
//    static func fetchUnpaidBill(completion: @escaping ([BillModel]?, Error?) -> Void) {
//        let db = Firestore.firestore()
//
//        db.collection("HoaDon").whereField("didDelete", isEqualTo: 0).whereField("didPay", isEqualTo: 0).order(by: "timeCreate").getDocuments { (snapshot, err) in
//            if err != nil {
//
//                print("Error getting BillModel Data: \(err!.localizedDescription)")
//                completion(nil, err)
//
//            } else if snapshot != nil, !snapshot!.documents.isEmpty {
//
//                getAllReferanceData(of: snapshot!) { (bills, error) in
//                    completion(bills, error)
//                }
//            } else {
//                completion([], nil)
//            }
//        }
//    }
    
//    static func getAllReferanceData(of snapshot: QuerySnapshot, completion: @escaping ([BillModel]?, Error?) -> Void) {
//        var bills = [BillModel]()
//        snapshot.documents.forEach({ (document) in
//            if var bill = BillModel(JSON: document.data()) {
//                var orderLoaded = false
//                var staffLoaded = false
//                Order.fetchAllData(ofBill: hoadon) { (datas, error) in
//                    if let orders = datas {
//                        hoadon.orderList = orders
//                    }
//                    orderLoaded = true
//                    if staffLoaded {
//                        bills.append(hoadon)
//                    }
//                    if bills.count == snapshot.documents.count {
//                        completion(bills, nil)
//                    }
//
//                    if error != nil {
//                        completion(nil, error)
//                    }
//                }
//                if let idnv = hoadon.idnhanvien {
//                    NhanVien.fetchData(forID: idnv) { (staff, error) in
//                        hoadon.staff = staff
//                        staffLoaded = true
//                        if orderLoaded {
//                            bills.append(hoadon)
//                        }
//                        if bills.count == snapshot.documents.count {
//                            completion(bills, nil)
//                        }
//                        if error != nil {
//                            completion(nil, error)
//                        }
//                    }
//                } else {
//                    staffLoaded = true
//                    if orderLoaded {
//                        bills.append(hoadon)
//                    }
//                    if bills.count == snapshot.documents.count {
//                        completion(bills, nil)
//                    }
//                }
//            }
//        })
//    }
}


