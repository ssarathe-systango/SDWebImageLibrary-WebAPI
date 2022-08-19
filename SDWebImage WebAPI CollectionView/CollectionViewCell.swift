//
//  CollectionViewCell.swift
//  SDWebImage WebAPI CollectionView
//
//  Created by macmini01 on 19/08/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "emptyImage")
    }
}
