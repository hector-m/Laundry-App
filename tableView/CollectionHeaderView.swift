//
//  CollectionHeaderView.swift
//  tableView
//
//  Created by Hector Morales on 3/13/17.
//  Copyright © 2017 Hector Morales. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var title: UILabel!
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath as IndexPath)
            if indexPath == [0,0]{
                title.text = "Washers"
            }
            if indexPath == [1,0] {
                title.text = "Dryers"
            }
            return headerView
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath as IndexPath)
            return footerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
}
