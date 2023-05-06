//
//  Food.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 19/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation
import ObjectMapper

struct FoodModel: Decodable, Mappable {
    
    
    
    var foodId: String! = UUID().uuidString
    var foodName: String? = ""
    var unit: String? = ""
    var unitPrice: Double? = 0
    var detail: String? = ""
    var placeImage: String? = ""
    var idKindOfFood: String? = ""
    var inBill: Int? = -1
    var didDelete: Int? = 0
    
    static func fetchMenuData(completion: @escaping ([FoodModel]?, Error?) -> Void) {
        let db = Firestore.firestore()
        var datas = [FoodModel]()

        db.collection("MonAn").whereField("daxoa", isEqualTo: 0).whereField("trongthucdon", isEqualTo: 1).order(by: "tenmonan").getDocuments { (snapshot, err) in
            if err != nil {
                
                print("Error getting BanAn Data: \(err!.localizedDescription)")
                completion(nil, err)
                
            } else if let snapshot = snapshot, !snapshot.documents.isEmpty {
                
                snapshot.documents.forEach({ (document) in
                    if let data = FoodModel(JSON: document.data()) {
                        datas.append(data)
                    }
                })
                completion(datas, nil)
            } else {
                completion(datas, nil)
            }
        }
    }
    
    static func fetchAllDataAvailable(completion: @escaping ([FoodModel]?, Error?) -> Void) {
        let db = Firestore.firestore()
        var datas = [FoodModel]()

        db.collection("MonAn").whereField("daxoa", isEqualTo: 0).order(by: "tenmonan").getDocuments { (snapshot, err) in
            if err != nil {
                
                print("Error getting BanAn Data: \(err!.localizedDescription)")
                completion(nil, err)
                
            } else if let snapshot = snapshot, !snapshot.documents.isEmpty {
                
                snapshot.documents.forEach({ (document) in
                    if let data = FoodModel(JSON: document.data()) {
                        datas.append(data)
                    }
                })
                completion(datas, nil)
            } else {
                completion(datas, nil)
            }
        }
    }
    
    static func fetchAllData(completion: @escaping ([FoodModel]?, Error?) -> Void) {
        let db = Firestore.firestore()
        var datas = [FoodModel]()

        db.collection("MonAn").order(by: "tenmonan").getDocuments { (snapshot, err) in
            if err != nil {
                
                print("Error getting BanAn Data: \(err!.localizedDescription)")
                completion(nil, err)
                
            } else if let snapshot = snapshot, !snapshot.documents.isEmpty {
                
                snapshot.documents.forEach({ (document) in
                    if let data = FoodModel(JSON: document.data()) {
                        datas.append(data)
                    }
                })
                completion(datas, nil)
            } else {
                completion(datas, nil)
            }
        }
    }

    static func fetchData(byOrder order: OrdersModel, completion: @escaping (FoodModel?, Error?) -> Void) {
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
    
    func updateInMenu(forDish dish: FoodModel, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()

        db.collection("MonAn").document(dish.foodId).updateData([
            "trongthucdon": dish.inBill,
        ]) { err in
            completion(err)
        }
        completion(nil)
    }
    
    init?() {
    }
    
    init?(map: ObjectMapper.Map) {
    }
    
    mutating func mapping(map: Map) {
        foodId <- map["idmonan"]
        foodName <- map["tenmonan"]
        unit <- map["donvimonan"]
        unitPrice <- map["dongia"]
        detail <- map["motachitiet"]
        placeImage <- map["diachianh"]
        idKindOfFood <- map["idtheloaimonan"]
        inBill <- map["trongthucdon"]
        didDelete <- map["daxoa"]
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(foodId)
    }
    
    static func == (lhs: FoodModel, rhs: FoodModel) -> Bool {
        return lhs.foodId == rhs.foodId
    }
}
