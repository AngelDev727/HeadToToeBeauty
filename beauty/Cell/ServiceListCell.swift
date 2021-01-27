//
//  HairServiceListCell.swift
//  beauty
//
//  Created by cs on 2020/3/4.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit

class ServiceListCell: UICollectionViewCell {
    
    @IBOutlet weak var lbl_serviceName: UILabel!
    @IBOutlet weak var img_serviceImage: UIImageView!
    
    var entity:ServiceModel! {
        
        didSet {
            img_serviceImage.image = UIImage(named: entity.serviceImage)
            lbl_serviceName.text = entity.serviceType
        }
    }
}
