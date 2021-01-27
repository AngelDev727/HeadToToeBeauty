//
//  SelectServiceCell.swift
//  beauty
//
//  Created by cs on 2020/4/7.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit

class SelectServiceCell: UITableViewCell {
    
    @IBOutlet weak var serviceCategoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var entity:ServiceTypeListModel! {
        
        didSet {
            
            serviceCategoryLabel.text = entity.serviceTypeName
            if entity.selected {
                self.accessoryType = .checkmark
            }else {
                self.accessoryType = .none
            }
        }
    }

}
