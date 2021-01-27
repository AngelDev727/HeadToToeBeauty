//
//  BookingCell.swift
//  beauty
//
//  Created by cs on 2020/3/6.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Kingfisher

class BookingCell: UITableViewCell {

    @IBOutlet weak var bookingProviderImage: UIImageView!
    @IBOutlet weak var lbl_bookingProviderName: UILabel!
    @IBOutlet weak var lbl_bookingAddress: UILabel!
    @IBOutlet weak var lbl_bookingServiceType: UILabel!
    @IBOutlet weak var lbl_bookingDate: UILabel!
    @IBOutlet weak var lbl_bookingTime: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var lbl_bookingComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var entity:BookingModel! {
        
        didSet {
            if userType == "client" {
                bookingProviderImage.kf.indicatorType = .activity
                bookingProviderImage.kf.setImage(with: URL(string: entity.bookingOppositePhoto), placeholder: UIImage(named: "avatar"))
                

            } else {
                bookingProviderImage.kf.indicatorType = .activity
                bookingProviderImage.kf.setImage(with: URL(string: entity.bookingOppositePhoto), placeholder: UIImage(named: "avatar"))
                
            }
            lbl_bookingProviderName.text = entity.bookingOppositeName
            lbl_bookingAddress.text = entity.bookingAddress
            lbl_bookingServiceType.text = entity.bookingType
            lbl_bookingDate.text = entity.bookingDate
            lbl_bookingTime.text = entity.bookingTime
            lbl_bookingComment.text = entity.bookingComment
        }
    }

}
