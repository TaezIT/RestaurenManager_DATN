//
//  RestaurentManagerViewModel.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 19/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation

class RestaurentManagerViewModel {
    
//    static func fetchMenuData(completion: @escaping ([FoodModel]?, Error?) -> Void) {
//        let db = Firestore.firestore()
//        var datas = [FoodModel]()
//
//        db.collection("MonAn").whereField("didDelete", isEqualTo: 0).whereField("inBill", isEqualTo: 1).order(by: "foodName").getDocuments { (snapshot, err) in
//            if err != nil {
//                print("Error getting BanAn Data: \(err!.localizedDescription)")
//                completion(nil, err)
//
//            } else if let snapshot = snapshot, !snapshot.documents.isEmpty {
//
//                snapshot.documents.forEach({ (document) in
//                    if let data = FoodModel(JSON: document.data()) {
//                        datas.append(data)
//                    }
//                })
//                completion(datas, nil)
//            } else {
//                completion(datas, nil)
//            }
//        }
//    }
//
//    static func fetchAllDataAvailable(completion: @escaping ([FoodModel]?, Error?) -> Void) {
//        let db = Firestore.firestore()
//        var datas = [FoodModel]()
//
//        db.collection("MonAn").whereField("didDelete", isEqualTo: 0).order(by: "FoodId").getDocuments { (snapshot, err) in
//            if err != nil {
//
//                print("Error getting BanAn Data: \(err!.localizedDescription)")
//                completion(nil, err)
//
//            } else if let snapshot = snapshot, !snapshot.documents.isEmpty {
//
//                snapshot.documents.forEach({ (document) in
//                    if let data = FoodModel(JSON: document.data()) {
//                        datas.append(data)
//                    }
//                })
//                completion(datas, nil)
//            } else {
//                completion(datas, nil)
//            }
//        }
//    }
//
//    static func fetchData(byOrder order: Order, completion: @escaping (MonAn?, Error?) -> Void) {
//        let db = Firestore.firestore()
//        guard let idmonan = order.idmonan else {
//            return
//        }
//        db.collection("MonAn").document(idmonan).getDocument { (snapshot, err) in
//            if err != nil {
//
//                print("Error getting BanAn Data: \(err!.localizedDescription)")
//                completion(nil, err)
//
//            } else if let data = snapshot?.data() {
//
//                let dish = MonAn(JSON: data)
//
//                completion(dish, nil)
//            } else {
//                completion(MonAn(), nil)
//            }
//        }
//    }
//
//    func updateInMenu(forDish dish: MonAn, completion: @escaping (Error?) -> Void) {
//        let db = Firestore.firestore()
//
//        db.collection("MonAn").document(dish.idmonan).updateData([
//            "trongthucdon": dish.trongthucdon,
//        ]) { err in
//            completion(err)
//        }
//        completion(nil)
//    }
//
//
}


