//
//  ServiceTypeCell.swift
//  beauty
//
//  Created by cs on 2020/4/9.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit

class ServiceTypeCell: UICollectionViewCell {
    
    @IBOutlet weak var nameTypeLabel: UILabel!
    
    var entity : ServiceTypeListModel! {
        
        didSet{
            
            nameTypeLabel.text = entity.serviceTypeName
        }
    }
}
