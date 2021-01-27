//
//  ReviewCell.swift
//  beauty
//
//  Created by cs on 2020/4/1.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var serviceTypeLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var entity:ReviewModel! {
        
        didSet {
            
            userPhotoImageView.kf.indicatorType = .activity
            userPhotoImageView.kf.setImage(with: URL(string: entity.customerPhoto), placeholder: UIImage(named: "avatar"))
            
            userNameLabel.text = entity.customerName
            serviceTypeLabel.text = entity.serviceType
            ratingView.rating = entity.rating
            ratingView.text = "\(entity.rating)/5.0"
            reviewDateLabel.text = entity.serviceDate
            feedbackLabel.text = entity.feedback
        }
    }

}

