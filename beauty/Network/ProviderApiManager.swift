//
//  ApiManager.swift
//  beauty
//
//  Created by cs on 2020/3/15.
//  Copyright © 2020 cs. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults

let HOST = "http://fromheadtotoebeauty.com/"
let API = HOST + "api/"
let PROVIDERAPI = API + "provider/"
let PROVIDERSIGNUP = PROVIDERAPI + "signup"
let PROVIDERLOGIN = PROVIDERAPI + "login"
let PROVIDERADDUSERPROFILE = PROVIDERAPI + "addUserProfile"
let PROVIDERGETSCHEDULE = PROVIDERAPI + "getSchedules"
let SERVICEREGISTER = PROVIDERAPI + "registMyService"
let PROVIDERUPDATEPROFILE = PROVIDERAPI + "updateProfile"
let PROVIDERADDSCHEDULE = PROVIDERAPI + "addSchedule"
let PROVIDERUPDATEPROILE = PROVIDERAPI + "updateProfile"
let PROVIDERFACEBOOKSIGNUPAPI = PROVIDERAPI + "signup_facebook"
let PROVIDERPAYMEMBERSHIP = PROVIDERAPI + "payMembeship"
let PROVIDERGETPAYTIME = PROVIDERAPI + "getPayDate"

let session = Alamofire.Session()
let multipartFormDataEncodingMemoryThreshold: UInt64 = 10_000_000
// MARK: - APIs

class ProviderApiManager : NSObject {
    class func signup(fullName: String, gender: String, email: String, phoneNumber: String, password: String, device_token: String, completion: @escaping(_ success:Bool, _ response: Any?)-> ()){
        
        let params = ["full_name": fullName, "email": email, "password": password, "gender": gender, "phone": phoneNumber, "device_token": device_token]
        
        session.request(PROVIDERSIGNUP, method: .post, parameters: params).responseJSON{ response in            
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
        
        session.request(PROVIDERFACEBOOKSIGNUPAPI, method: .post, parameters: params).responseJSON{ response in
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
    
    class func login(email: String, password: String, login_type:String, device_token: String, completion: @escaping(_ success:Bool, _ response: Any?)-> ()){
        
        let params = ["email": email, "password": password, "login_type": login_type, "device_token": device_token]
        
        session.request(PROVIDERLOGIN, method: .post, parameters: params).responseJSON{ response in
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
            to: PROVIDERADDUSERPROFILE,
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
    
    class func getSchedule(user_id: Int, completion:@escaping (_ success: Bool, _ response:Any?) ->Void){      
        
        let params = ["provider_id": user_id] as [String : Any]
        session.request(PROVIDERGETSCHEDULE, method: .post, parameters: params).responseJSON { response in
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
    
    class func registerService(userId: Int, service_id: String, description: String, isTravelService: Int, address: String, latitude: Double, longitude: Double, certifications: [UIImage], mainImage: UIImage, logoImage: UIImage, fb_link: String, insta_link: String, business_name: String, completion: @escaping (_ success: Bool, _ response:Any?) ->Void) {
        let headers: [String: String] = ["Content-Type": "application/x-www-form-urlencoded"]
        
        let params: [String: String] = ["provider_id": "\(userId)",
                                        "service_type": "\(service_id)",
                                        "description": description,
                                        "is_travelwork": "\(isTravelService)",
                                        "latitude": "\(latitude)",
                                        "longitude": "\(longitude)",
                                        "facebook_link": "\(fb_link)",
                                        "instagram_link": "\(insta_link)",
                                        "business_name": business_name
                                    ]
        
        let upload = session.upload(
            multipartFormData: { (multipartFormData) in
                for i in 0...certifications.count-1 {
                    let data = certifications[i].jpegData(compressionQuality: 0.8)
                    multipartFormData.append(data!, withName: "certification[\(i)]", fileName: "certification_\(i)" + ".jpg", mimeType: "image/jpeg")
                }
                let mainImageData = mainImage.jpegData(compressionQuality: 0.8)
                let logoImageData = logoImage.jpegData(compressionQuality: 0.8)
                multipartFormData.append(mainImageData!, withName: "main_image", fileName: "main_image" + ".jpg", mimeType: "image/jpeg")
                multipartFormData.append(logoImageData!, withName: "service_logo", fileName: "service_logo" + ".jpg", mimeType: "image/jpeg")
                for (key, value) in params {
                    if let data = value.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: SERVICEREGISTER,
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
                let user_Info = dict[CONSTANT.USER_DATA].arrayValue

                if result == "success" {
                    completion(true, user_Info)
                } else {
                    completion(false, data)
                }
                            
            }
        }
    }
    
    class func addSchedule(client_id: Int, provider_id: Int, user_type: String, service_id: String, scheduleTime: Int, address: String, comment: String, isTravelService: String, user_name: String, completion:@escaping (_ success: Bool, _ response:Any?) ->Void){
        
        let params = ["client_id": client_id, "provider_id": provider_id, "user_type": user_type, "service_id": service_id, "schedule_datetime": scheduleTime, "address": address, "comment": comment, "is_travel": isTravelService,"user_name": user_name] as [String : Any]
        
        session.request(PROVIDERADDSCHEDULE, method: .post, parameters: params).responseJSON { response in
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
    
    class func updateProfile(providerId: Int, userName: String, userPhoto: UIImage, phoneNumber: String, password: String, address: String, gender: String, completion: @escaping (_ success: Bool, _ response:Any?) ->Void) {
        
        let headers: [String: String] = ["Content-Type": "application/x-www-form-urlencoded"]
        
        let params: [String: String] = ["provider_id": "\(providerId)",
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
            to: PROVIDERUPDATEPROILE,
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
    
    class func payMembership(provider_id: Int, pay_date: Int, membership_type: Int, completion:@escaping (_ success: Bool, _ response:Any?) ->Void){
        
        let params = ["provider_id": provider_id,
                      "pay_datetime": pay_date,
                      "membership_type": membership_type] as [String : Any]
        
        session.request(PROVIDERPAYMEMBERSHIP, method: .post, parameters: params).responseJSON { response in
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
    
    class func getPayTime(provider_id: Int, completion:@escaping (_ success: Bool, _ response:Any?) ->Void){
        
        let params = ["provider_id": provider_id] as [String : Any]
        
        session.request(PROVIDERGETPAYTIME, method: .post, parameters: params).responseJSON { response in
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
}

