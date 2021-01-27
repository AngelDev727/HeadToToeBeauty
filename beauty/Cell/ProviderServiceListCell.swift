//
//  ProviderServiceListCell.swift
//  beauty
//
//  Created by cs on 2020/3/12.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit

class ProviderServiceListCell: UITableViewCell {

    @IBOutlet weak var serviceNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var entity:ProviderServiceListModel! {
           
           didSet {
            serviceNameLabel.text = entity.serviceName
           }
       }
}
