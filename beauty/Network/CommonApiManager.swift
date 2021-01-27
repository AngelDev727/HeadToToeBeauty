//
//  CommonApiManager.swift
//  beauty
//
//  Created by cs on 2020/3/18.
//  Copyright © 2020 cs. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftyUserDefaults
import Alamofire

let FORGOTPASSWORD = PROVIDERAPI + "forgotPWD"
let RESETPASSWORD = PROVIDERAPI + "resetPWD"
let WRITEMESSAGE = PROVIDERAPI + "writeMessege"
let READMESSAGE = PROVIDERAPI + "readMessege"
let GETCHATLIST = PROVIDERAPI + "getChatList"
let GETUNREADMESSAGECOUNT = PROVIDERAPI + "getUnreadMSGCount"

class CommonApiManager : NSObject {
    
    class func forgotPassword(user_type: String, email: String, completion:@escaping (_ success: Bool, _ response:Any?) ->Void){
        let params = ["user_type": user_type, "email": email]
        session.request(FORGOTPASSWORD, method: .post, parameters: params).responseJSON { response in
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                let dict = JSON(data)
                let result = dict[CONSTANT.RESULT].stringValue
                
                if result == "success" {
                    completion(true, data)
                } else {
                    completion(false, result)
                }
            }
        }
    }
    
    class func resetPassword(user_id: Int, user_type: String, password: String, completion:@escaping (_ success: Bool, _ response:Any?) ->Void){
        let params = ["user_id": user_id, "user_type": user_type, "password": password] as [String : Any]
        session.request(RESETPASSWORD, method: .post, parameters: params).responseJSON { response in
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                let dict = JSON(data)
                let result = dict[CONSTANT.RESULT].stringValue
                
                if result == "success" {
                    completion(true, result)
                } else {
                    completion(false, result)
                }
            }
        }
    }
    
    class func writeMessage(client_id: Int, provider_id: Int, chatroom_id: String, sender_type: String, content: String, completion:@escaping (_ success: Bool, _ response:Any?) ->Void){
        let params = ["client_id": client_id, "provider_id": provider_id, "chatroom_id": chatroom_id, "sender_type": sender_type, "content": content] as [String : Any]
        session.request(WRITEMESSAGE, method: .post, parameters: params).responseJSON { response in
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                let dict = JSON(data)
                let result = dict[CONSTANT.RESULT].stringValue
                
                if result == "success" {
                    completion(true, result)
                } else {
                    completion(false, result)
                }
            }
        }
    }
    
    class func readMessage(client_id: Int, provider_id: Int, chatroom_id: String, reader_type: String, completion:@escaping (_ success: Bool, _ response:Any?) ->Void){
        
        let params = ["client_id": client_id, "provider_id":provider_id, "chatroom_id": chatroom_id, "reader_type": reader_type] as [String : Any]
           session.request(READMESSAGE, method: .post, parameters: params).responseJSON { response in
               switch response.result {
                   
               case .failure:
                   completion(false, nil)
                   
               case .success(let data):
                   let dict = JSON(data)
                   let result = dict[CONSTANT.RESULT].stringValue
                   
                   if result == "success" {
                       completion(true, result)
                   } else {
                       completion(false, result)
                   }
               }
           }
       }
    
    class func getChatList(user_id: Int, userType: String, completion:@escaping (_ success: Bool, _ response:Any?) ->Void){
     
        let params = ["user_id": user_id, "user_type": userType] as [String : Any]
        session.request(GETCHATLIST, method: .post, parameters: params).responseJSON { response in
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                let dict = JSON(data)
                let result = dict[CONSTANT.RESULT].stringValue
                
                if result == "success" {
                    completion(true, data)
                } else {
                    completion(false, result)
                }
            }
        }
    }
    
    class func getUnreadMessageCount(user_id: Int, user_type: String, completion:@escaping (_ success: Bool, _ response:Any?) ->Void){
        let params = ["user_id": user_id, "user_type": user_type] as [String : Any]
        session.request(GETUNREADMESSAGECOUNT, method: .post, parameters: params).responseJSON { response in
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                let dict = JSON(data)
                let result = dict[CONSTANT.RESULT].stringValue
                
                if result == "success" {
                    completion(true, data)
                } else {
                    completion(false, result)
                }
            }
        }
    }
}
