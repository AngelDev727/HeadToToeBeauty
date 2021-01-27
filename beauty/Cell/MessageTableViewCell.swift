//
//  MessageTableViewCell.swift
//  beauty
//
//  Created by cs on 2020/3/30.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit

protocol MessageTableViewCellDelegate: class {
  func messageTableViewCellUpdate()
}

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var txv_message: UITextView!
    @IBOutlet weak var lbl_time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func set(_ message: MessageModel) {
           txv_message?.text = message.message
           lbl_time.text = getMessageTimeFromTimeStamp(message.time)
       }
}
