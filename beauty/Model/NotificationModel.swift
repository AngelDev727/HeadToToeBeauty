//
//  NotificationModel.swift
//  beauty
//
//  Created by cs on 2020/3/8.
//  Copyright © 2020 cs. All rights reserved.
//

import Foundation

class NotificationModel {
    
    var notificationTitle : String
    var notificationContent : String
    
    init (notificationTitle: String, notificationContent: String) {
        
        self.notificationTitle = notificationTitle
        self.notificationContent = notificationContent
    }
}
