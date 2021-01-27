//
//  ReviewModel.swift
//  beauty
//
//  Created by cs on 2020/4/1.
//  Copyright © 2020 cs. All rights reserved.
//

import Foundation
import SwiftyJSON


class ReviewModel {
    
    var customerPhoto = ""
    var customerName = ""
    var serviceType = ""
    var serviceDate = ""
    var rating : Double = 0
    var feedback = ""
    
    init(dict: JSON) {
        
        self.customerPhoto = dict["user_photo"].stringValue
        self.customerName = dict["client_name"].stringValue
        let serviceTypeId = dict["service_type"].stringValue
        self.serviceType = CONSTANT.serviceTypeNames["\(serviceTypeId)"]!
        let serviceDateTimeStamp = dict["created_timestamp"].stringValue
        self.serviceDate = getStrDate(serviceDateTimeStamp)
        self.feedback = dict["feedback"].stringValue
        self.rating = dict["rating"].doubleValue
    }
}
