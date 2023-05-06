//
//  CartTotalsViewModel.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 05/04/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation

class CartTotalsViewModel {
    
    static func getAllReferanceData(of snapshot: QuerySnapshot, completion: @escaping ([ReportModel]?, Error?) -> Void) {
        
        var reports = [ReportModel]()
        
        snapshot.documents.forEach({ (document) in
            if var baocao = ReportModel(JSON: document.data()) {
                
                self.fetchData(forID: baocao.idStaff) { (staff, error) in
                    baocao.staff = staff
                    reports.append(baocao)
                    if reports.count == snapshot.documents.count {
                        completion(reports, nil)
                    }
                }
            }
        })
    }
    
    static func fetchData(forID id: String, completion: @escaping (StaffModel?, Error?) -> Void) {
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
}
