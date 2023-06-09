//
//  Staff.swift
//  RestaurantManager_DATN
//
//  Created by Tuấn Anh on 23/03/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation
import ObjectMapper

struct StaffModel: Decodable, Mappable {
    var staffId: String! = UUID().uuidString
    var staffName: String = ""
    var phoneNumber: String = ""
    var email: String = ""
    var place: String = ""
    var authority: Int = -1
    var idLoginAccount: String = ""
    var didSelected: Int = 0
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(staffId)
    }
    
    init?(map: ObjectMapper.Map) {
    }
    
    init?() {
    }
    
    mutating func mapping(map: Map) {
        staffId <- map["idnhanvien"]
        staffName <- map["tennhanvien"]
        phoneNumber <- map["sodienthoai"]
        email <- map["email"]
        place <- map["diachi"]
        authority <- map["quyen"]
        idLoginAccount <- map["idtaikhoandangnhap"]
        didSelected <- map["daxoa"]
    }
    
    func getPosition() -> String {
        switch authority {
        case 0:
            return "Admin"
        case 1:
            return "Quản lý nhà hàng"
        case 2:
            return "Nhân viên thu ngân"
        case 3:
            return "Nhân viên phục vụ"
        case 4:
            return "Quản lý nhà bếp"
        case 5:
            return "Quản lý nhà kho"
        default:
            return "nil"
        }
    }
    
    static func fetchAllData(completion: @escaping ([StaffModel]?, Error?) -> Void) {
        var datas = [StaffModel]()
        let db = Firestore.firestore()
        
        db.collection("NhanVien").order(by: "tennhanvien").getDocuments { (snapshot, err) in
            if err != nil {
                completion(nil, err)
                
            } else if let snapshot = snapshot, !snapshot.documents.isEmpty {
                snapshot.documents.forEach({ (document) in
                    if let data = StaffModel(JSON: document.data()) {
                        datas.append(data)
                    }
                })
                completion(datas, nil)
            } else {
                completion(datas, nil)
            }
        }
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
    
    static func fetchAllManagerData(completion: @escaping ([StaffModel]?, Error?) -> Void) {
        var datas = [StaffModel]()
        let db = Firestore.firestore()
        
        db.collection("NhanVien").whereField("quyen", in: [1,4,5]).whereField("daxoa", isEqualTo: 0).order(by: "tennhanvien").getDocuments { (snapshot, err) in
            if err != nil {
                completion(nil, err)
                
            } else if let snapshot = snapshot, !snapshot.documents.isEmpty {
                
                snapshot.documents.forEach({ (document) in
                    if let data = StaffModel(JSON: document.data()) {
                        datas.append(data)
                    }
                })
                completion(datas, nil)
            } else {
                completion(datas, nil)
            }
        }
    }
}
