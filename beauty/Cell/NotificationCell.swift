//
//  NotificationCell.swift
//  beauty
//
//  Created by cs on 2020/3/9.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var notificationTitle: UILabel!
    @IBOutlet weak var notificationContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var entity:NotificationModel! {
        
        didSet {
            
            notificationTitle.text = entity.notificationTitle
            notificationContent.text = entity.notificationContent
        }
    }

}
