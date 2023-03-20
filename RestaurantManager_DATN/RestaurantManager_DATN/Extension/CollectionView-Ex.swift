//
//  CollectionView-Extension.swift
//  Soha
//
//  Created by Truong Thang on 24/11/2022.
//  Copyright © 2022 Le Duc Anh. All rights reserved.
//

import Foundation
import UIKit


extension UICollectionView {
    func registerCellByNib<T: UICollectionViewCell>(_ type: T.Type) {
        register(type.nib, forCellWithReuseIdentifier: type.identifier)
    }
    
    func registerCell<T: UICollectionViewCell>(_ type: T.Type) {
        register(type, forCellWithReuseIdentifier: type.identifier)
    }
    
    func registerView<T: UICollectionReusableView>(_ type: T.Type, ofKind kind: String) {
        register(type.nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: type.identifier)
    }
    
    func dequeueCell<T: UICollectionViewCell>(_ type: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T else { fatalError() }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(_ type: T.Type, ofKind kind: String, forIndexPath indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.identifier, for: indexPath) as? T else { fatalError() }
        return view
    }
    
    func removeEmptyView() {
        self.backgroundView = nil
    }
}
