//
//  Orders.swift
//  RestaurantManager_DATN
//
//  Created by Tuấn Anh on 23/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation
import ObjectMapper

struct OrdersModel: Decodable, Mappable {
    
    var ordersId: String! = UUID().uuidString
    var billId: String? = ""
    var numberOfOrders: Int = 1
    var status: Int = 0
    var foodId: String? = ""
    var timeCreate: Date?
    var didDelete: Int? = 0
    var dish: FoodModel?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        ordersId <- map["idorder"]
        foodId <- map["idmonan"]
        billId <- map["idhoadon"]
        numberOfOrders <- map["soluong"]
        status <- map["trangthai"]
        var timestamp: Timestamp?
        timestamp <- map["ngaytao"]
        timeCreate = timestamp?.dateValue().getDateFormatted()
        didDelete <- map["daxoa"]
    }
    
    static func == (lhs: OrdersModel, rhs: OrdersModel) -> Bool {
        return lhs.ordersId == rhs.ordersId
    }
    
    func getState(forNextState: Bool = false) -> String {
        var trangthai = self.status
        if forNextState {
            trangthai += 1
        }
        switch trangthai {
        case 0:
            return "Đang chờ"
        case 1:
            return "Đang nấu"
        case 2:
            return "Đã nấu"
        case 3:
            return "Hoàn thành"
        default:
            return "nil"
        }
    }
    
    static func fetchAllData(ofBill bill: BillModel ,
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
                        FoodModel.fetchData(byOrder: order) { (dish, error) in
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
}
