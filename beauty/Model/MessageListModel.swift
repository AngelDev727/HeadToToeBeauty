//
//  MessageListModel.swift
//  beauty
//
//  Created by cs on 2020/3/9.
//  Copyright © 2020 cs. All rights reserved.
//

import Foundation
import SwiftyJSON

class MessageListModel {
    
    var senderPhoto : String
    var senderName : String
    var senderId = 0
    var date : String
    var messageContent : String
    var unreadNumber : String
    
  
    
    init (senderPhoto: String, senderName: String, date: String, messageContent: String, unreadNumber: String) {
        
        self.senderPhoto = senderPhoto
        self.senderName = senderName
        self.date = date
        self.messageContent = messageContent
        self.unreadNumber = unreadNumber
    }
    
    init(dict: JSON) {
        if userType == "provider"  {
            self.senderPhoto = dict["client_photo"].stringValue
            self.senderName = dict["client_name"].stringValue
            self.senderId = dict["client_id"].intValue
        } else {
            self.senderPhoto = dict["provider_photo"].stringValue
            self.senderName = dict["provider_name"].stringValue
            self.senderId =  dict["provider_id"].intValue
        }
        let timestamp = dict["last_timestamp"].doubleValue * 1000
        self.date = getMessageTimeFromTimeStamp(Int64(timestamp))
        self.messageContent = dict["last_message"].stringValue
        self.unreadNumber = dict["unread_count"].stringValue
    }
}
