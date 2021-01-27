//
//  CustomerApiManager.swift
//  beauty
//
//  Created by cs on 2020/3/15.
//  Copyright © 2020 cs. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyUserDefaults
import SwiftyJSON

let CUSTOMERAPI = API + "users/"
let CUSTOMERSIGNUP = CUSTOMERAPI + "signup"
let CUSTOMERLOGIN = CUSTOMERAPI + "login"
let CUSTOMERADDPROFILE = CUSTOMERAPI + "addUserProfile"
let FINDPROVIDERBYLOCATION = CUSTOMERAPI + "searchProviderByLocation"
let FINDPROVIDERBYNAME = CUSTOMERAPI + "searchProviderByName"
let GETPROVIDERINFO = CUSTOMERAPI + "getProviderInfo"
let CUSTOMERGETSCHEDULE = CUSTOMERAPI + "getSchedules"
let ADDREVIEW = CUSTOMERAPI + "addReview"
let CUSTOMERADDSCHEDULE = CUSTOMERAPI + "addSchedule"
let CUSTOMERUPDATEPROFILE = CUSTOMERAPI + "updateProfile"
let CUSTOMERFACEBOOKSIGNUP = CUSTOMERAPI + "signup_facebook"


class CustomerApiManager : NSObject {
    class func signup(fullName: String, gender: String, email: String, phoneNumber: String, password: String, device_token: String, completion: @escaping(_ success:Bool, _ response: Any?)-> ()){
        
        let params = ["full_name": fullName, "email": email, "password": password, "gender": gender, "phone": phoneNumber, "device_token": device_token]
        
        session.request(CUSTOMERSIGNUP, method: .post, parameters: params).responseJSON{ response in
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                let dict = JSON(data)
                let result = dict[CONSTANT.RESULT].stringValue
                
                if result == "success" {
                    let userData = dict[CONSTANT.USER_DATA]
                    completion(true, userData)
                } else {
                    completion(false, data)
                }
                            
            }
        }
    }
    
    
    class func facebookSignup(fullName: String, email:String, password: String,device_token: String, photo: String, completion: @escaping (_ success: Bool, _ response:Any?) ->Void) {
       
        
        let params = ["full_name": fullName, "email": email, "password": password, "device_token": device_token, "photo": photo]
        
        session.request(CUSTOMERFACEBOOKSIGNUP, method: .post, parameters: params).responseJSON{ response in
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                let dict = JSON(data)
                let result = dict[CONSTANT.RESULT].stringValue
                
                if result == "success" {
                    let userData = dict[CONSTANT.USER_DATA]
                    completion(true, userData)
                } else {
                    completion(false, data)
                }
                            
            }
        }
    }
    
    class func login(email: String, password: String, login_type: String, device_token: String, completion: @escaping(_ success:Bool, _ response: Any?)-> ()){
        
        let params = ["email": email, "password": password, "login_type":login_type, "device_token": device_token]
        
        session.request(CUSTOMERLOGIN, method: .post, parameters: params).responseJSON{ response in
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                let dict = JSON(data)
                let result = dict[CONSTANT.RESULT].stringValue
                
                if result == "success" {
                    completion(true, data)
                } else {
                    completion(false, data)
                }         
            }
        }
    }
    
    class func addProfile(userId: Int, address: String, latitude: Double, longitude: Double, file: UIImage, completion: @escaping (_ success: Bool, _ response:Any?) ->Void) {
        let headers: [String: String] = ["Content-Type": "application/x-www-form-urlencoded"]
        let userId_string = "\(userId)"
        let latitude_string = "\(latitude)"
        let longitude_string = "\(longitude)"
        let params: [String: String] = ["user_id": userId_string,
                                     "address": address,
                                     "latitude": latitude_string,
                                     "longitude": longitude_string
                                    ]
        
        let upload = session.upload(
            multipartFormData: { (multipartFormData) in
                let data = file.jpegData(compressionQuality: 0.8)
                multipartFormData.append(data!, withName: "photo", fileName: "photo" + ".jpg", mimeType: "image/jpeg")
                for (key, value) in params {
                    if let data = value.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: CUSTOMERADDPROFILE,
            usingThreshold: multipartFormDataEncodingMemoryThreshold,
            method: .post,
            headers: HTTPHeaders(headers),
            interceptor: nil,
            fileManager: FileManager.default)
        
        upload.responseJSON { (response) in
            print("multipart response", response)
            
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                let dict = JSON(data)
                print("dict", dict)
                let result = dict[CONSTANT.RESULT].stringValue
               
                if result == "success" {
                    completion(true, data)
                } else {
                    completion(false, data)
                }       
            }
        }
    }
    
    class func findProviderByLocation(service_id: Int, latitude: Double, longitude: Double, completion:@escaping (_ success: Bool, _ response:Any?) ->Void){
        let params = ["service_id": service_id, "latitude": latitude, "longitude": longitude] as [String : Any]
        session.request(FINDPROVIDERBYLOCATION, method: .post, parameters: params).responseJSON { response in
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                let dict = JSON(data)
                let result = dict[CONSTANT.RESULT].stringValue
                
                if result == "success" {
                    completion(true, data)
                } else {
                    completion(false, data)
                }
            }
        }
    }
    
    class func findProviderByName(service_id: Int, providerName: String, completion:@escaping (_ success: Bool, _ response:Any?) ->Void){
        let params = ["service_id": service_id, "provider_name": providerName] as [String : Any]
        session.request(FINDPROVIDERBYNAME, method: .post, parameters: params).responseJSON { response in
            switch response.result {
               
            case .failure:
               completion(false, nil)
               
            case .success(let data):
               let dict = JSON(data)
               let result = dict[CONSTANT.RESULT].stringValue
               if result == "success" {
                   completion(true, data)
               } else {
                   completion(false, data)
               }
            }
        }
    }
    
    class func getProviderInfo(provider_id: Int, completion:@escaping (_ success: Bool, _ response:Any?) ->Void){
        let params = ["provider_id": provider_id] as [String : Any]
        session.request(GETPROVIDERINFO, method: .post, parameters: params).responseJSON { response in
            switch response.result {
               
            case .failure:
               completion(false, nil)
               
            case .success(let data):
               let dict = JSON(data)
               let result = dict[CONSTANT.RESULT].stringValue
               if result == "success" {
                   completion(true, data)
               } else {
                   completion(false, data)
               }
            }
        }
    }
    
    class func getSchedule(user_id: Int, completion:@escaping (_ success: Bool, _ response:Any?) ->Void){
        let params = ["user_id": user_id] as [String : Any]
        session.request(CUSTOMERGETSCHEDULE, method: .post, parameters: params).responseJSON { response in
            switch response.result {
               
            case .failure:
               completion(false, nil)
               
            case .success(let data):
               let dict = JSON(data)
               let result = dict[CONSTANT.RESULT].stringValue
               if result == "success" {
                   completion(true, data)
               } else {
                   completion(false, data)
               }
            }
        }
    }
    
    class func addReview(user_id: Int, provider_id: Int, rating: Double, feedback: String, photos: [UIImage], serviceType: Int, completion:@escaping (_ success: Bool, _ response:Any?) ->Void){
        
        let headers: [String: String] = ["Content-Type": "application/x-www-form-urlencoded"]
        
        let params : [String: String] = ["user_id": "\(user_id)",
                                        "provider_id": "\(provider_id)",
                                        "rating": "\(rating)",
                                        "feedback": feedback,
                                        "service_type": "\(serviceType)"
                                        ]
        
        let upload = session.upload(
            multipartFormData: { (multipartFormData) in
                
                for item in photos {
                    let data = item.jpegData(compressionQuality: 0.8)
                    multipartFormData.append(data!, withName: "photo_url[]", fileName: "photo_url_\(getCurrentTimeStamp())" + ".jpg", mimeType: "image/jpeg")
                }
                
                for (key, value) in params {
                    if let data = value.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: ADDREVIEW,
            usingThreshold: multipartFormDataEncodingMemoryThreshold,
            method: .post,
            headers: HTTPHeaders(headers),
            interceptor: nil,
            fileManager: FileManager.default
        )
        
        upload.responseJSON { (response) in
            print("multipart response", response)
            
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                let dict = JSON(data)
                print("dict", dict)
                let result = dict[CONSTANT.RESULT].stringValue
               
                if result == "success" {
                    completion(true, data)
                } else {
                    completion(false, data)
                }
            }
        }
    }
    
    class func addSchedule(client_id: Int, provider_id: Int, user_type: String, service_id: String, scheduleTime: Int, address: String, comment: String, isTravelService: String, user_name: String, completion:@escaping (_ success: Bool, _ response:Any?) ->Void){
        
        let params = ["client_id": client_id, "provider_id": provider_id, "user_type": user_type, "service_id": service_id, "schedule_datetime": scheduleTime, "address": address, "comment": comment, "is_travel": isTravelService,"user_name": user_name] as [String : Any]
        
        session.request(CUSTOMERADDSCHEDULE, method: .post, parameters: params).responseJSON { response in
            switch response.result {
               
            case .failure:
               completion(false, nil)
               
            case .success(let data):
               let dict = JSON(data)
               let result = dict[CONSTANT.RESULT].stringValue
               if result == "success" {
                   completion(true, data)
               } else {
                   completion(false, data)
               }
            }
        }
    }
    
    class func updateProfile(userId: Int, userName: String, userPhoto: UIImage, phoneNumber: String, password: String, address: String, gender: String, completion: @escaping (_ success: Bool, _ response:Any?) ->Void) {
        
        let headers: [String: String] = ["Content-Type": "application/x-www-form-urlencoded"]
        
        let params: [String: String] = ["users_id": "\(userId)",
                                        "user_name": userName,
                                        "phone": phoneNumber,
                                        "password": password,
                                        "address": address,
                                        "gender": gender
                                    ]
        
        let upload = session.upload(
            multipartFormData: { (multipartFormData) in
                let data = userPhoto.jpegData(compressionQuality: 0.8)
                multipartFormData.append(data!, withName: "photo_url", fileName: "photo_url" + ".jpg", mimeType: "image/jpeg")
                for (key, value) in params {
                    if let data = value.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: CUSTOMERUPDATEPROFILE,
            usingThreshold: multipartFormDataEncodingMemoryThreshold,
            method: .post,
            headers: HTTPHeaders(headers),
            interceptor: nil,
            fileManager: FileManager.default)
        
        upload.responseJSON { (response) in
            print("multipart response", response)
            
            switch response.result {
                
            case .failure:
                completion(false, nil)
                
            case .success(let data):
                let dict = JSON(data)
                print("dict", dict)
                let result = dict[CONSTANT.RESULT].stringValue
               
                if result == "success" {
                    completion(true, data)
                } else {
                    completion(false, data)
                }
                            
            }
        }
    }
    
    
}
