//
//  SignInVC.swift
//  beauty
//
//  Created by cs on 2020/2/28.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import Toast_Swift
import IQKeyboardManagerSwift
import SwiftyUserDefaults
import GDCheckbox
import FAPanels
import SwiftyJSON
import MBProgressHUD
import FBSDKLoginKit

class SignInVC: BaseViewController {
    
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var btn_customer: GDCheckbox!
    @IBOutlet weak var btn_provider: GDCheckbox!
    var hud : MBProgressHUD!
    
    var email = ""
    var password = ""
    var loginType = ""
    var fullName = ""
    var photoUrl = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn_customer.isRadiobox = true
        btn_provider.isRadiobox = true
        btn_provider.checkWidth = 8
        btn_customer.checkWidth = 8
        
        if Defaults[\.userRegistered] {
            
            email = Defaults[\.userEmail]!
            password = Defaults[\.userPwd]!
            loginType = Defaults[\.userLoginType]!
            
            if Defaults[\.userType] == "client" {
                userType = "client"
                onCallCustomerLoginApi()
            }else {
                userType = "provider"
                onCallProviderLoginApi()
            }
        }
    }
    
    @IBAction func onClickRadio(_ sender: UIButton) {
        
        if sender.tag == 0 {
            btn_customer.isOn = true
            btn_provider.isOn = false
            btn_customer.isCircular = true
            userType = "client"
        } else {
            btn_provider.isOn = true
            btn_provider.isCircular = true
            btn_customer.isOn = false
            userType = "provider"
        }
    }
    
    @IBAction func onClickForgot(_ sender: Any) {
        
        gotoNavVC("ForgotVC")
    }
    
    @IBAction func onClickSignIn(_ sender: Any) {
     
        email = txt_email.text!
        password = txt_password.text!
        
        if email.isEmpty {
            showToast(R.string.INPUT_EMAIL)
            return
        }
        
        if password.isEmpty {
            showToast(R.string.INPUT_PASSWORD)
            return
        }
        
        if !isValidEmail(email: email) {
            showToast(R.string.INVALID_EMAIL)
            return
        }
        Defaults[\.userLoginType] = "email"
        loginType = "email"
        if btn_customer.isOn == true {
            onCallCustomerLoginApi()
        } else {
            onCallProviderLoginApi()
        }
    }
    
    func onCallCustomerLoginApi() {

        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        CustomerApiManager.login(email: email, password: password, login_type: loginType, device_token: "dfasdfdsfa", completion: {(isSuccess, data) in
        
            if (isSuccess){
                let userData = JSON(data as Any)
                let dict = userData[CONSTANT.USER_DATA]
                let user_id = dict[CONSTANT.USER_ID].intValue
                let user_name = dict[CONSTANT.USER_NAME].stringValue
                let user_gender = dict[CONSTANT.USER_GENDER].stringValue
                let phoneNumber = dict[CONSTANT.USER_PHONE_NUMBER].stringValue
                let myLat = dict[CONSTANT.MY_LAT].doubleValue
                let myLng = dict[CONSTANT.MY_LNG].doubleValue
                let userPhotoUrl = dict[CONSTANT.USER_PHOTO_URL].stringValue
                let userLocation = dict[CONSTANT.USER_ADDRESS].stringValue
                Defaults[\.userId] = user_id
                Defaults[\.userName] = user_name
                Defaults[\.userEmail] = self.email
                Defaults[\.userGender] = user_gender
                Defaults[\.userPwd] = self.password
                Defaults[\.userPhoneNumber] = phoneNumber
                Defaults[\.userPhotoUrl] = userPhotoUrl
                Defaults[\.userLocation] = userLocation
                Defaults[\.userRegistered] = true
                Defaults[\.myLat] = myLat
                Defaults[\.myLng] = myLng
                userType = "client"
                Defaults[\.userType] = "client"
                self.hud.hide(animated: true)
                self.gotoCustomerVC("HomeVC")
                
            }else{
               if data == nil {
                   self.showToast("Failed to connect to server", duration: 2, position: .bottom)
               } else {
                   let dict = JSON(data as Any)
                   let result = dict[CONSTANT.RESULT].stringValue
                   let message = dict[CONSTANT.MESSAGE].stringValue
                   if result == "fail" {
                       self.showToast("\(message)", duration: 2, position: .bottom)
                   }
                   else {
                       self.showToast("Error", duration: 2, position: .bottom)
                   }
               }
                self.hud.hide(animated: true)
            }
        })
    }
    
    func onCallProviderLoginApi() {
        
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        ProviderApiManager.login(email: email, password: password, login_type: "email", device_token: "asdfadsfa", completion: {(isSuccess, data) in
            
            if (isSuccess){
                let userData = JSON(data as Any)
                let dict = userData[CONSTANT.USER_DATA]
                let user_id = dict[CONSTANT.USER_ID].intValue
                let user_gender = dict[CONSTANT.USER_GENDER].stringValue
                let user_name = dict[CONSTANT.USER_NAME].stringValue
                let phoneNumber = dict[CONSTANT.USER_PHONE_NUMBER].stringValue
                let userPhotoUrl = dict[CONSTANT.USER_PHOTO_URL].stringValue
                let userLocation = dict[CONSTANT.USER_ADDRESS].stringValue
                let myLat = dict[CONSTANT.MY_LAT].doubleValue
                let myLng = dict[CONSTANT.MY_LNG].doubleValue
                var expireMembershipTimeStamp = dict[CONSTANT.PROVIDER_EXPIRE_DATE].stringValue
                expireMembershipTimeStamp = expireMembershipTimeStamp == "" ? "0" : expireMembershipTimeStamp
                let expireMembershipDate = getStrDate(expireMembershipTimeStamp)
                Defaults[\.userId] = user_id
                Defaults[\.userName] = user_name
                Defaults[\.userEmail] = self.email
                Defaults[\.userGender] = user_gender
                Defaults[\.userPwd] = self.password
                Defaults[\.userPhoneNumber] = phoneNumber
                Defaults[\.userPhotoUrl] = userPhotoUrl
                Defaults[\.userLocation] = userLocation
                Defaults[\.userExpireMembershipDate] = expireMembershipDate
                Defaults[\.myLat] = myLat
                Defaults[\.myLng] = myLng
                Defaults[\.userRegistered] = true
                userType = "provider"
                Defaults[\.userType] = "provider"
                self.hud.hide(animated: true)
                self.gotoProviderVC("ProviderHomeVC")
                
            }else{
               if data == nil {
                   self.showToast("Failed to connect to server", duration: 2, position: .bottom)
               } else {
                   let dict = JSON(data as Any)
                   let result = dict[CONSTANT.RESULT].stringValue
                   let message = dict[CONSTANT.MESSAGE].stringValue
                   if result == "fail" {
                       self.showToast("\(message)", duration: 2, position: .bottom)
                   }
                   else {
                       self.showToast("Error", duration: 2, position: .bottom)
                   }
               }
                self.hud.hide(animated: true)
            }
        })
    }
    
    @IBAction func onClickFaceBook(_ sender: Any) {
        
        loginType = "facebook"
        Defaults[\.userLoginType] = "facebook"
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if(fbloginresult.grantedPermissions.contains("email")) {
                    self.getFBUserData()
                    fbLoginManager.logOut()
                }
            } else {
                print("Login failed")
            }
        }
    }
    
    func getFBUserData(){
        
        if((AccessToken.current) != nil) {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, first_name, last_name"]).start(completionHandler: { (connection, result, error) -> Void in
                
                if (error == nil) {
                    
                    let jsonResponse = JSON(result!)
                    
                    print("jsonResponse", jsonResponse)
                    
                    let id = jsonResponse["id"].stringValue
                    self.password = id
                    self.email = jsonResponse["email"].string ?? String(format: "%@@facebook.com", id)
                    self.fullName = jsonResponse["name"].string ?? "unknown"
                    self.photoUrl = "https://graph.facebook.com/" + id + "/picture?type=large"
                    
                    
                    print("FB result", self.email, id)
                    if  self.btn_customer.isOn {
                        userType = "client"
                        self.onCustomerFacebookSignup()
                        
                    } else {
                        userType = "provider"
                        self.onProviderFacebookSignup()
                    }
                    
                } else {
                    // TODO:  Exeption  ****
                    print(error!)
                }
            })
        } else {
            print("token is null")
        }
    }
    
    
    @IBAction func onClickSignUp(_ sender: Any) {

        gotoNavVC("SignupVC")
    }
    
    func onCustomerFacebookSignup() {
        
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        
        CustomerApiManager.facebookSignup(fullName: fullName, email: email, password: password, device_token: "facebook_customer_signup", photo: photoUrl, completion: {(isSuccess,data) in

            self.hud.hide(animated: true)
            if isSuccess{
                
                let dict = JSON(data as Any)
                let user_id = dict[CONSTANT.USER_ID].intValue
                Defaults[\.userId] = user_id
                Defaults[\.userEmail] = self.email
                Defaults[\.userPwd] = self.password
                Defaults[\.userName] = self.fullName
                Defaults[\.userPhotoUrl] = self.photoUrl
                if Defaults[\.serviceRegistered] == 0 {
                    self.gotoNavVC("CreateProfileVC")
                }else {
                    self.gotoCustomerVC("HomeVC")
                }
            }
            else{
                if data == nil {
                    self.showToast("Failed to connect to server", duration: 2, position: .bottom)
                } else {
                    let dict = JSON(data as Any)
                    let result = dict[CONSTANT.RESULT].stringValue
                    let message = dict[CONSTANT.MESSAGE].stringValue
                    if result == "fail" {
                        self.showToast("\(message)", duration: 2, position: .bottom)
                    }
                    else {
                        self.showToast("Error", duration: 2, position: .bottom)
                    }
                }
            }
        })
    }
    
    func onProviderFacebookSignup() {
        
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        
        ProviderApiManager.facebookSignup(fullName: fullName, email: email, password: password, device_token: "facebook_provider_signup", photo: photoUrl, completion: {(isSuccess,data) in

            self.hud.hide(animated: true)
            if isSuccess{
                
                let dict = JSON(data as Any)
                let user_id = dict[CONSTANT.USER_ID].intValue
                Defaults[\.userId] = user_id
                Defaults[\.userEmail] = self.email
                Defaults[\.userPwd] = self.password
                Defaults[\.userName] = self.fullName
                Defaults[\.userPhotoUrl] = self.photoUrl
                if Defaults[\.serviceRegistered] == 0 {
                    self.gotoNavVC("CreateProfileVC")
                }else {
                    self.gotoProviderVC("ProviderHomeVC")
                }
            }
            else{
                if data == nil {
                    self.showToast("Failed to connect to server", duration: 2, position: .bottom)
                } else {
                    let dict = JSON(data as Any)
                    let result = dict[CONSTANT.RESULT].stringValue
                    let message = dict[CONSTANT.MESSAGE].stringValue
                    if result == "fail" {
                        self.showToast("\(message)", duration: 2, position: .bottom)
                    }
                    else {
                        self.showToast("Error", duration: 2, position: .bottom)
                    }
                }
            }
        })
    }
}
