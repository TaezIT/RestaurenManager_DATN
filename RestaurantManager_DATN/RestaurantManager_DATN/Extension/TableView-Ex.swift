//
//  TableView-Extension.swift
//  Soha
//
//  Created by Truong Thang on 24/11/2022.
//  Copyright © 2022 Le Duc Anh. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    func registerCellByNib<T: UITableViewCell>(_ type: T.Type) {
        register(type.nib, forCellReuseIdentifier: type.identifier)
    }
    
    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: type.identifier)
    }
    
    func registerHeaderFoooter<T: UIView>(byNib type: T.Type) {
        register(type.nib, forHeaderFooterViewReuseIdentifier: type.identifier)
    }
    
    func registerHeaderFoooter<T: UIView>(byClass type: T.Type) {
        register(type.self, forHeaderFooterViewReuseIdentifier: type.identifier)
    }
    
    func dequeueCell<T: UITableViewCell>(_ type: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T else { fatalError() }
        return cell
    }
    
    func dequeueCell<T: UITableViewCell>(_ type: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.identifier) as? T else { fatalError() }
        return cell
    }
    
    func dequeueHeaderFooter<T: UIView>(_ type: T.Type) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: type.identifier) as? T else { fatalError() }
        return view
    }
    
    func removeEmptyView() {
        self.backgroundView = nil
    }
    
    func scrollToBottom(animated: Bool = true) {
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)
        if (rows > 0) {
            self.scrollToRow(at: IndexPath(row: rows - 1, section: sections - 1), at: .bottom, animated: true)
        }
    }
}
