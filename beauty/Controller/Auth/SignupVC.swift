//
//  SignupVC.swift
//  beauty
//
//  Created by cs on 2020/2/28.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyUserDefaults
import iOSDropDown
import GDCheckbox
import MBProgressHUD
import SKCountryPicker
import SwiftyJSON
import FBSDKLoginKit


class SignupVC: BaseViewController {
    
    @IBOutlet weak var txt_confirmPassword: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_phoneNumber: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_gender: UITextField!
    @IBOutlet weak var txt_userName: UITextField!
    @IBOutlet weak var genderDropDown: DropDown!
    @IBOutlet weak var btn_customer: GDCheckbox!
    @IBOutlet weak var btn_provider: GDCheckbox!
    @IBOutlet weak var img_flag: UIImageView!
    @IBOutlet weak var btn_dialCode: UIButton!
    @IBOutlet weak var termsButton: GDCheckbox!
    var hud : MBProgressHUD!
    
    var fullName = ""
    var photoUrl = ""
    var password = ""
    var email = ""
    
    var countryCode = "+1"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        
        setGenderDropDown()
        setCountryCode()
    }
    
    func setCountryCode() {
        
        guard let country = CountryManager.shared.currentCountry else {
            self.btn_dialCode.setTitle("Pick Country", for: .normal)
            self.img_flag.isHidden = true
            return
        }
        
        btn_dialCode.setTitle(country.dialingCode, for: .normal)
        countryCode = country.dialingCode!
        img_flag.image = country.flag
        btn_dialCode.clipsToBounds = true
    }
    
    func setGenderDropDown() {
        
        genderDropDown.optionArray = ["Male", "Female", "I chose not to say"]
      
        genderDropDown.isSearchEnable = false
        genderDropDown.selectedRowColor = .clear
        genderDropDown.rowHeight = 40
        genderDropDown.checkMarkEnabled = true
        genderDropDown.arrowColor = .white      
        genderDropDown.didSelect(completion: { (selected, index, id)  in
            self.genderDropDown.text = selected
        })
    }
    
    @IBAction func onClickRadio(_ sender: UIButton) {
        
        if sender.tag == 0 {
            btn_customer.isOn = true
            btn_customer.isCircular = true
            btn_provider.isOn = false
        } else {
            btn_provider.isOn = true
            btn_provider.isCircular = true
            btn_customer.isOn = false
        }
    }
    
    @IBAction func onClickDialCode(_ sender: Any) {
        
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in

            guard let self = self else { return }

            self.countryCode = country.dialingCode!            
            self.img_flag.image = country.flag
            self.btn_dialCode.setTitle(country.dialingCode, for: .normal)

        }

        countryController.detailColor = UIColor.red
        CountryManager.shared.addFilter(.countryCode)
        CountryManager.shared.addFilter(.countryDialCode)
    }
    
    @IBAction func onClickSignup(_ sender: Any) {
        
        let userName = txt_userName.text!
        let gender = txt_gender.text!
        let email = txt_email.text!
        let empty_phoneNumber = txt_phoneNumber.text!
        let password = txt_password.text!
        let confirmPassword = txt_confirmPassword.text!
        let phoneNumber = empty_phoneNumber
        
        if btn_customer.isOn == false && btn_provider.isOn == false {
            showToast(R.string.SELECT_USERTYPE)
        }
        if userName.isEmpty {
            showToast(R.string.INPUT_NAME)
            return
        }
        if gender.isEmpty {
            showToast(R.string.INPUT_GENDER)
            return
        }
        if email.isEmpty {
            showToast(R.string.INPUT_EMAIL)
            return
        }
        if empty_phoneNumber.isEmpty {
            showToast(R.string.INPUT_PHONENUMBER)
            return
        }
        if password.isEmpty {
            showToast(R.string.INPUT_PASSWORD)
            return
        }
        if confirmPassword.isEmpty {
            showToast(R.string.CONFIRM_PASSWORD)
            return
        }
        
        if password != confirmPassword {
            showToast(R.string.INVALID_PWD)
            return
        }
        
        if !isValidEmail(email: email) {
            showToast(R.string.INVALID_EMAIL)
            return
        }
        
        if termsButton.isOn == false {
            showToast(R.string.CHECK_TERMS)
            return
        }
        
        Defaults[\.userLoginType] = "email"
                
        if btn_customer.isOn{
            
            self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
            self.hud.show(animated: true)
            CustomerApiManager.signup(fullName: userName, gender: gender, email: email, phoneNumber: phoneNumber, password: password, device_token: "dsfasdfasdfasd", completion: {(isSuccess,data) in

                if isSuccess{
                    
                    let dict = JSON(data!)
                    let user_id = dict[CONSTANT.USER_ID].intValue
                    let myLat = dict[CONSTANT.MY_LAT].doubleValue
                    let myLng = dict[CONSTANT.MY_LNG].doubleValue
                    Defaults[\.userId] = user_id
                    Defaults[\.userName] = userName
                    Defaults[\.userGender] = gender
                    Defaults[\.userEmail] = email
                    Defaults[\.userPhoneNumber] = phoneNumber
                    Defaults[\.userPwd] = password
                    Defaults[\.myLat] = myLat
                    Defaults[\.myLng] = myLng
                    userType = "client"
                    Defaults[\.userType] = "client"
                    self.hud.hide(animated: true)
                    self.gotoNavVC("CreateProfileVC")
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
                    self.hud.hide(animated: true)
                }
            })
        } else {
            
            self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
            self.hud.show(animated: true)
            ProviderApiManager.signup(fullName: userName, gender: gender, email: email, phoneNumber: phoneNumber, password: password, device_token: "asdfasdfasdfa", completion: {(isSuccess,data) in

                if isSuccess{
                    let dict = JSON(data!)
                    let user_id = dict[CONSTANT.USER_ID].intValue
                    let myLat = dict[CONSTANT.MY_LAT].doubleValue
                    let myLng = dict[CONSTANT.MY_LNG].doubleValue
                    Defaults[\.userId] = user_id
                    Defaults[\.userName] = userName
                    Defaults[\.userGender] = gender
                    Defaults[\.userEmail] = email
                    Defaults[\.userPhoneNumber] = phoneNumber
                    Defaults[\.userPwd] = password
                    Defaults[\.myLat] = myLat
                    Defaults[\.myLng] = myLng
                    userType = "provider"
                    Defaults[\.userType] = "provider"
                    self.hud.hide(animated: true)
                    self.gotoNavVC("CreateProfileVC")
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
                    self.hud.hide(animated: true)
                }
            })       
        }
    }
    
    @IBAction func onClickCheckTerms(_ sender: Any) {
        
        if termsButton.isOn {
            termsButton.isOn = false
        } else {
            termsButton.isOn = true
        }
    }
    
    @IBAction func onClickTerms(_ sender: Any) {
        
        if let url = URL(string: "http://fromheadtotoebeauty.com/terms") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func onClickPrivacy(_ sender: Any) {
        
        if let url = URL(string: "http://fromheadtotoebeauty.com/privacy") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func onClickFaceBook(_ sender: Any) {
        
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
                    
                    print("FB result", self.fullName, self.email, id, self.photoUrl)
                    
                    if self.btn_customer.isOn {
                        userType = "client"
                        Defaults[\.userType] = userType
                        self.onCustomerFacebookSignup()
                    }else {
                        userType = "provider"
                        Defaults[\.userType] = userType
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
    
    func onCustomerFacebookSignup() {
        
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        
        CustomerApiManager.facebookSignup(fullName: fullName, email: email, password: password, device_token: "facebook_signup_customer", photo: photoUrl, completion: {(isSuccess,data) in

            self.hud.hide(animated: true)
            if isSuccess{
                let dict = JSON(data as Any)
                let user_id = dict[CONSTANT.USER_ID].intValue
                Defaults[\.userId] = user_id
                Defaults[\.userEmail] = self.email
                Defaults[\.userPwd] = self.password
                Defaults[\.userName] = self.fullName
                Defaults[\.userPhotoUrl] = self.photoUrl
                self.gotoNavVC("CreateProfileVC")
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
                self.hud.hide(animated: true)
            }
        })
    }
    
    func onProviderFacebookSignup() {
        
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        
        ProviderApiManager.facebookSignup(fullName: fullName, email: email, password: password, device_token: "facebook_signup_provider", photo: photoUrl, completion: {(isSuccess,data) in

            self.hud.hide(animated: true)
            if isSuccess{
                let dict = JSON(data as Any)
                let user_id = dict[CONSTANT.USER_ID].intValue
                Defaults[\.userId] = user_id
                Defaults[\.userEmail] = self.email
                Defaults[\.userPwd] = self.password
                Defaults[\.userName] = self.fullName
                Defaults[\.userPhotoUrl] = self.photoUrl
                self.gotoNavVC("CreateProfileVC")
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
                self.hud.hide(animated: true)
            }
        })
    }
    
    @IBAction func onClickLogin(_ sender: Any) {
        doDismiss()
    }
    
}
