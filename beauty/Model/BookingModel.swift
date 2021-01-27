//
//  BookingModel.swift
//  beauty
//
//  Created by cs on 2020/3/6.
//  Copyright © 2020 cs. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftyUserDefaults

class BookingModel {
    
    var bookingOppositePhoto = ""
    var bookingOppositeName = ""
    var bookingAddress = ""
    var bookingType = ""
    var bookingDate = ""
    var bookingTime = ""
    var bookingComment = ""
    var isTavelService = ""
        
    init(bookingOppositePhoto: String, bookingOppositeName: String, bookingAddress: String, bookingType: String, bookingDate: String, bookingTime: String, bookingComment: String, isTravelService: String){
        self.bookingOppositePhoto = bookingOppositePhoto
        self.bookingOppositeName = bookingOppositeName
        self.bookingAddress = bookingAddress        
        self.bookingType = bookingType
        self.bookingDate = bookingDate
        self.bookingTime = bookingTime
        self.bookingComment = bookingComment
        self.isTavelService = isTravelService
    }
    
    init(dict: JSON) {
        if userType == "client" {
            self.bookingOppositePhoto = dict["provider_photo"].stringValue
        } else {
            self.bookingOppositePhoto = dict["user_photo"].stringValue
        }
        self.bookingOppositeName = dict["user_name"].stringValue
        self.bookingAddress = dict["address"].stringValue
        let serviceId = dict["service_id"].stringValue
        let serviceName = CONSTANT.serviceTypeNames[serviceId]!
        self.bookingType = serviceName
        let bookingDateTime = dict["schedule_datetime"].stringValue
        
        self.bookingDate = getStrDate(bookingDateTime)
        self.bookingTime = getStrTime(bookingDateTime)
        self.bookingComment = dict["comment"].stringValue
        self.isTavelService = dict["is_travel"].stringValue
        
    }
}
