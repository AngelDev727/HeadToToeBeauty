//
//  MessageModel.swift
//  beauty
//
//  Created by cs on 2020/3/15.
//  Copyright © 2020 cs. All rights reserved.
//

import Foundation
import UIKit

class MessageModel {
    
    var receiver_id: String = ""
    var sender_id: String = ""
    var message: String = ""
    var contentType = ContentType.none
    var time: Int64 = 0
    var receiver_img: String = ""
    var sender_img: String = ""
    var receiver_name: String = ""
    var sender_name: String = ""
    
    enum ContentType: Int {
      case none
      case photo
      case location
      case unknown
    }
    
    class func parseMessageData(ary: NSArray) -> NSMutableArray {
        
        let muary = NSMutableArray()
        
        for index in 0 ..< ary.count {
            
            let dict = ary.object(at: index) as! [String: Any]
            
            let objList = MessageModel()
            objList.message = DataChecker .getValidationstring(dict: dict, key: "message")
            objList.receiver_id = DataChecker .getValidationstring(dict: dict, key: "receiver_id")
            objList.sender_id = DataChecker .getValidationstring(dict: dict, key: "sender_id")
            objList.time = Int64(DataChecker .getValidationstring(dict: dict, key: "time"))!
            
            muary.add(objList)
        }
        
        return muary
    }
}
