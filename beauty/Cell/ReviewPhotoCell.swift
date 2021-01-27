//
//  ReviewPhotoCell.swift
//  beauty
//
//  Created by cs on 2020/3/7.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import Kingfisher


class ReviewPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var img_reviewPhoto: UIImageView!
    
    var entity : ReviewPhotoModel! {
        
        didSet{
            
            if let image = entity.imgFile {
                
                img_reviewPhoto.image = image
                
            } else if let remote = entity.imgUrl {
                img_reviewPhoto.kf.indicatorType = .activity
                img_reviewPhoto.kf.setImage(with: URL(string: remote), placeholder: UIImage(named: "placeholder"))
                
            }
            
        }
    }
}
