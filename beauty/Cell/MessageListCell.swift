//
//  MessageListCell.swift
//  beauty
//
//  Created by cs on 2020/3/9.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import Kingfisher

class MessageListCell: UITableViewCell {

    @IBOutlet weak var senderPhoto: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var sendDate: UILabel!
    @IBOutlet weak var messageFirstContent: UILabel!
    @IBOutlet weak var unreadNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var entity:MessageListModel! {
        
        didSet {
            
            senderPhoto.kf.indicatorType = .activity
            senderPhoto.kf.setImage(with: URL(string: entity.senderPhoto), placeholder: UIImage(named: "avatar"))
            
            senderName.text = entity.senderName
            sendDate.text = entity.date
            messageFirstContent.text = entity.messageContent
            if entity.unreadNumber == "0" {
                unreadNumber.isHidden = true
                unreadNumber.text = entity.unreadNumber
            }else{
                unreadNumber.text = entity.unreadNumber
            }
        }
    }
}
