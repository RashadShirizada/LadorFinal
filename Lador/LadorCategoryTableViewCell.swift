//
//  LadorCategoryTableViewCell.swift
//  Lador
//
//  Created by Developer on 12/29/17.
//  Copyright © 2017 Development. All rights reserved.
//

import UIKit

class LadorCategoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
       
        collectionView.frame.size = CGSize(width:self.contentView.frame.width,height: self.contentView.frame.height)
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
}
