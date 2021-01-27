//
//  Constant.swift
//  beauty
//
//  Created by cs on 2020/3/15.
//  Copyright © 2020 cs. All rights reserved.
//

import Foundation
import UIKit
struct CONSTANT {
    static let APP_NAME = "Head To Toe"
    static let REVIEW = "reviews"
    
    static let PAYPAL_SANDBOX_KEY           = "AZEs7CYweCoa4EQgmj1wEPsM-yAIdnYYUUGcVLBAbDOsQ30AQ1LmjFaIwCGIAJZY_SP4rE_svupiA801"
    static let PAYPAL_PRODUCTION_KEY        = "AcvNXeIQWW_vsqVPk5jWkM1EfEJuMUn6DHUtEbCp1F7PyBledp0B12TwSdXiiYphsrXGcjqdA2WGOq4B"
    
    static let COLOR_MAIN = UIColor.white
    static let RESULT = "res"
    static let USER_DATA = "user_data"
    static let OK = "OK"
    static let USER_ID = "row_id"
    static let USER_NAME = "full_name"
    static let USER_PHOTO_URL = "photo_url"
    static let USER_EMAIL = "email"
    static let USER_PHONE_NUMBER = "phone_num"
    static let USER_ADDRESS = "address"
    static let USER_GENDER = "gender"
    static let PHOTO = "photo"
    static let MY_LAT = "latitude"
    static let MY_LNG = "longitude"
    
    static let PROVIDER_RATING = "rating"
    static let PROVIDER_LOGO = "service_logo"
    static let PROVIDER_MAINIMAGE = "service_main_img"
    static let PROVIDER_CERTIFICATION = "certifications"
    static let PROVIDER_DESCRIPTION = "service_description"
    static let PROVIDER_TRAVELSERVICE = "is_travelwork"
    static let PROVIDER_SERVICETYPE = "service_type"
    static let PROVIDER_EXPIRE_DATE = "exp_timestamp"
    static let PROVIDER_BUSINESS_NAME = "business_name"
    static let PROVIDER_FACEBOOK_LINK = "facebook_link"
    static let PROVIDER_INSTAGRAM_LINK = "instagram_link"
    static let MEMBERSHIP_STATE = "membership_state"
    static let STATE = "state"
    static let TYPE = "type"
    static let PAY_TIMESTAMP = "pay_timestamp"
    
    static let PREVIOUS_SCHEDULE = "prevoius_schedule"
    static let INCOMING_SCHEDULE = "incoming_schedule"
    
    
    static let OTP = "otp"
    static let MESSAGE = "msg"
    
    static let serviceTypeNames: [String: String] = [
        "10" : "Hair cut",
        "11" : "Hair color",
        "12" : "Styling & finishing",
        "13" : "Hair texture",
        "14" : "Hair treatments",
        "15" : "Hair men's services",
        
        "20" : "Manicure",
        "21" : "Pedicure",
        "22" : "Artificial nails",
        "23" : "Hair removal",
        "24" : "Lash extension",
        "25" : "Makeup",
        "26" : "Skin & body"
        ]
}
