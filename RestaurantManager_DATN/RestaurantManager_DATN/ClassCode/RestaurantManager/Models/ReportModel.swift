//
//  ReportModel.swift
//  RestaurantManager_DATN
//
//  Created by Phạm Tuấn Anh on 05/04/2023.
//  Copyright © 2023 Pham Tuan Anh. All rights reserved.
//

import Foundation
import ObjectMapper

struct ReportModel: Decodable, Mappable {
    var idReport: String! = UUID().uuidString
    var idStaff: String = ""
    var title: String = ""
    var content: String = ""
    var timeCreate: Date?
    var typeReport: Int = 0
    var didDelete: Int = 0
    var staff: StaffModel?

    init?() {
        
    }
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        idReport <- map["idbaocao"]
        idStaff <- map["idnhanvien"]
        title <- map["tieude"]
        var timestamp: Timestamp?
        timestamp <- map["ngaytao"]
        timeCreate = timestamp?.dateValue().getDateFormatted() ?? Date()
        content <- map["noidung"]
        typeReport <- map["loaibaocao"]
        didDelete <- map["daxoa"]
    }
    
    static func getAllReferanceData(of snapshot: QuerySnapshot, completion: @escaping ([ReportModel]?, Error?) -> Void) {
        
        var reports = [ReportModel]()
        
        snapshot.documents.forEach({ (document) in
            if var baocao = ReportModel(JSON: document.data()) {
                
                StaffModel.fetchData(forID: baocao.idStaff) { (staff, error) in
                    baocao.staff = staff
                    reports.append(baocao)
                    if reports.count == snapshot.documents.count {
                        completion(reports, nil)
                    }
                }
            }
        })
    }
    
    static func fetchAllData(completion: @escaping ([ReportModel]?, Error?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("BaoCao").order(by: "ngaytao").getDocuments { (snapshot, err) in
            if err != nil {
                
                completion(nil, err)
                
            } else if let snapshot = snapshot, !snapshot.documents.isEmpty {
                
                getAllReferanceData(of: snapshot, completion: completion)
            } else {
                completion([], nil)
            }
        }
    }
}
