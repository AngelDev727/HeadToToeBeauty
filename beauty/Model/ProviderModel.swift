//
//  ProviderModel.swift
//  beauty
//
//  Created by cs on 2020/3/5.
//  Copyright © 2020 cs. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProviderModel {
    
    var providerImage = ""
    var providerName = ""
    var providerAddress = ""
    var providerRating : Double = 0
    var provider_id = 0
    var providerEmail = ""
    var providerPhoneNumber = ""
    var providerLogoImageUrl = ""
    var providerMainImageUrl = ""
    var providerServiceType = ""
    var providerCertificationImageUrl = ""
    var providerDescription = ""
    var isTravelService = 0
    var latitude = 0.0
    var longitude = 0.0
    var business_name = ""
    var facebook_link = ""
    var instagram_link = ""
    var membership_state = ""
    var paytime = ""
    var exptime = ""
    var membership_type = 0
        
    init(providerImage: String, providerName: String, providerAddress: String, providerRating: Double){
        self.providerImage = providerImage
        self.providerName = providerName
        self.providerAddress = providerAddress
        self.providerRating = providerRating
    }
    
    init(dict: JSON) {
        self.provider_id = dict[CONSTANT.USER_ID].intValue
        self.providerImage = dict[CONSTANT.USER_PHOTO_URL].stringValue
        self.providerName = dict[CONSTANT.USER_NAME].stringValue
        self.providerAddress = dict[CONSTANT.USER_ADDRESS].stringValue
        self.providerRating = dict[CONSTANT.PROVIDER_RATING].doubleValue
        self.providerEmail = dict[CONSTANT.USER_EMAIL].stringValue
        self.providerPhoneNumber = dict[CONSTANT.USER_PHONE_NUMBER].stringValue
        self.providerLogoImageUrl = dict[CONSTANT.PROVIDER_LOGO].stringValue
        self.providerMainImageUrl = dict[CONSTANT.PROVIDER_MAINIMAGE].stringValue
        self.providerCertificationImageUrl = dict[CONSTANT.PROVIDER_CERTIFICATION].stringValue
        self.providerServiceType = dict[CONSTANT.PROVIDER_SERVICETYPE].stringValue
        self.isTravelService = dict[CONSTANT.PROVIDER_TRAVELSERVICE].intValue
        self.providerDescription = dict[CONSTANT.PROVIDER_DESCRIPTION].stringValue
        self.latitude = dict[CONSTANT.MY_LAT].doubleValue
        self.longitude = dict[CONSTANT.MY_LNG].doubleValue
        self.business_name = dict[CONSTANT.PROVIDER_BUSINESS_NAME].stringValue
        self.facebook_link = dict[CONSTANT.PROVIDER_FACEBOOK_LINK].stringValue
        self.instagram_link = dict[CONSTANT.PROVIDER_INSTAGRAM_LINK].stringValue
        
        var exptimeStamp = dict[CONSTANT.PROVIDER_EXPIRE_DATE].stringValue
        if exptimeStamp == "" {
            exptimeStamp = "0"
        }
        self.exptime = getStrDate(String(Int(exptimeStamp)! * 1000))
        
        if dict[CONSTANT.MEMBERSHIP_STATE].exists() {
        
            var payTimeStamp = dict[CONSTANT.MEMBERSHIP_STATE][CONSTANT.PAY_TIMESTAMP].stringValue
            if payTimeStamp == "" {
                payTimeStamp = "0"
            }
            self.paytime = getStrDate(String(Int(payTimeStamp)! * 1000))            
            self.membership_state = dict[CONSTANT.MEMBERSHIP_STATE][CONSTANT.STATE].stringValue
            self.membership_type = dict[CONSTANT.MEMBERSHIP_STATE][CONSTANT.TYPE
            ].intValue
        }
    }
}
