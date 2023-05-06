//
//  Table.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 19/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation
import ObjectMapper

struct TableModel: Decodable, Mappable {
    
    var tableId: String! = UUID().uuidString
    var numberOrdinalTable: String? = ""
    var numberOfChair: Int? = -1
    var didDelete: Int? = 0
    var bill: BillModel?
    
    static func == (lhs: TableModel, rhs: TableModel) -> Bool {
        return lhs.tableId == rhs.tableId
    }
    
    static func fetchAllDataAvailable(completion: @escaping ([TableModel]?, Error?) -> Void) {
        var banans = [TableModel]()
        let db = Firestore.firestore()

        db.collection("BanAn").whereField("daxoa", isEqualTo: 0).order(by: "sobanan").getDocuments { (snapshot, err) in
            if err != nil {
                
                print("Error getting BanAn Data: \(err!.localizedDescription)")
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
    
    static func fetchAllData(completion: @escaping ([FoodModel]?, Error?) -> Void) {
        var banans = [FoodModel]()
        let db = Firestore.firestore()

        db.collection("BanAn").order(by: "sobanan").getDocuments { (snapshot, err) in
            if err != nil {
                
                print("Error getting BanAn Data: \(err!.localizedDescription)")
                completion(nil, err)
                
            } else if snapshot != nil, !snapshot!.documents.isEmpty {
                
                snapshot!.documents.forEach({ (document) in
                    if let banan = FoodModel(JSON: document.data()) {
                        banans.append(banan)
                    }
                })
                completion(banans, nil)
            } else {
                completion(banans, nil)
            }
        }
    }
    
    static func fetchData(ofID id: String, completion: @escaping (FoodModel?, Error?) -> Void) {
        if id == "" {
            completion(nil,nil)
            return
        }
        var banan: FoodModel?
        let db = Firestore.firestore()

        db.collection("BanAn").document(id).getDocument { (snapshot, err) in
            if err != nil {
                
                print("Error getting BanAn Data: \(err!.localizedDescription)")
                completion(nil, err)
                
            } else if snapshot != nil, snapshot?.data() != nil {
                
                banan = FoodModel(JSON: snapshot!.data()!)
                completion(banan, nil)
                
            } else {
                completion(banan, nil)
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(tableId)
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        tableId <- map["idbanan"]
        numberOrdinalTable <- map["sobanan"]
        numberOfChair <- map["soluongghe"]
        didDelete <- map["daxoa"]
    }
}
