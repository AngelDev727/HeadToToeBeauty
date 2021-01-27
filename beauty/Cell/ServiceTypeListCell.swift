//
//  ServiceTypeListCell.swift
//  beauty
//
//  Created by cs on 2020/3/20.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit

class ServiceTypeListCell: UITableViewCell {

    @IBOutlet weak var serviceTypeNameLable: UILabel!
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
            serviceTypeNameLable.text = entity.serviceTypeName
        }
    }
}
