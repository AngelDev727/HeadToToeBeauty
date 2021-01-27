//
//  ProviderListCell.swift
//  beauty
//
//  Created by cs on 2020/3/5.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher

class ProviderListCell: UITableViewCell {

    @IBOutlet weak var img_providerImage: UIImageView!
    @IBOutlet weak var lbl_providerName: UILabel!
    @IBOutlet weak var lbl_providerAddress: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var viewButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var entity:ProviderModel! {
        
        didSet {
            
            img_providerImage.kf.indicatorType = .activity
            img_providerImage.kf.setImage(with: URL(string: entity.providerImage), placeholder: UIImage(named: "avatar"))
            
            lbl_providerName.text = entity.business_name
            lbl_providerAddress.text = entity.providerAddress
            ratingView.text = "\(entity.providerRating)" + "/5.0"
            ratingView.rating = entity.providerRating
        }
    }

}
