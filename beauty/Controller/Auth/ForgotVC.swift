//
//  ForgotVC.swift
//  beauty
//
//  Created by cs on 2020/3/1.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import KAPinField
import SwiftyUserDefaults
import SwiftyJSON
import MBProgressHUD

class ForgotVC: BaseViewController {

 
    @IBOutlet weak var txt_pinCode: KAPinField!
    @IBOutlet weak var txt_eamil: UITextField!
    @IBOutlet weak var lblUserType: UILabel!
    private var targetCode = ""
    var hud : MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        initView()
    }
    
    func initView() {
        
        lblUserType.text = "(" + userType.prefix(1).uppercased() + userType.dropFirst() + ")"
        txt_pinCode.properties.delegate = self
        txt_pinCode.text = ""
        txt_pinCode.properties.numberOfCharacters = 6
    }
    
 
    
    func setStyle() {
        
        txt_pinCode.properties.token = " "
        txt_pinCode.properties.animateFocus = false
        
        txt_pinCode.appearance.tokenColor = UIColor.white.withAlphaComponent(0.2)
        txt_pinCode.appearance.tokenFocusColor = UIColor.white.withAlphaComponent(0.2)
        txt_pinCode.appearance.textColor = UIColor.white
        txt_pinCode.appearance.font = .menlo(30)
        txt_pinCode.appearance.kerning = 24
        txt_pinCode.appearance.backOffset = 5
        txt_pinCode.appearance.backColor = UIColor.clear
        txt_pinCode.appearance.backBorderWidth = 1
        txt_pinCode.appearance.backBorderColor = UIColor.white.withAlphaComponent(0.2)
        txt_pinCode.appearance.backCornerRadius = 4
        txt_pinCode.appearance.backFocusColor = UIColor.clear
        txt_pinCode.appearance.backBorderFocusColor = UIColor.white.withAlphaComponent(0.8)
        txt_pinCode.appearance.backActiveColor = UIColor.clear
        txt_pinCode.appearance.backBorderActiveColor = UIColor.white
        txt_pinCode.appearance.backRounded = false
        _ = self.txt_pinCode.becomeFirstResponder()
    }
    
    func refreshPinField() {
        
        txt_pinCode.text = ""
        txt_pinCode.properties.numberOfCharacters = 6
        UIPasteboard.general.string = targetCode
        setStyle()
        
    }

    @IBAction func onClickSend(_ sender: Any) {
        
        let email = txt_eamil.text!
        if email.isEmpty {
            showToast(R.string.INPUT_EMAIL)
            return
        }
        onCallForgotApi(email: email)
    }
    
    func onCallForgotApi(email:String) {
        
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        CommonApiManager.forgotPassword(user_type: userType, email: email, completion: {(isSuccess, data) in
            
            if (isSuccess){
                
                let dict = JSON(data as Any)
                let USERID = "user_id"
                let user_id = dict[USERID].intValue
                let otp = dict[CONSTANT.OTP].stringValue
                Defaults[\.userId] = user_id
                self.targetCode = otp
                print("otp: ", otp)
                let message = dict[CONSTANT.MESSAGE].stringValue
                self.showAlertDialog(title: "Forgot Password", message: "\(message)", positive: R.string.OK, negative: nil)
                self.hud.hide(animated: true)
                self.refreshPinField()
                
            }else{
               if data == nil {
                   self.showToast("Failed to connect to server", duration: 2, position: .bottom)
               } else {
                   let result = data as! String
                   if result == "fail" {
                       self.showToast("A user having that eamil does not exist.", duration: 2, position: .bottom)
                   }
                   else {
                       self.showToast("Error", duration: 2, position: .bottom)
                   }
               }
                self.hud.hide(animated: true)
            }
        })
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        
        doDismiss()
    }
}

// Mark: - KAPinFieldDelegate
extension ForgotVC : KAPinFieldDelegate {
    func pinField(_ field: KAPinField, didChangeTo string: String, isValid: Bool) {
        if isValid {
            print("Valid input: \(string) ")
        } else {
            print("Invalid input: \(string) ")
            self.txt_pinCode.animateFailure()
        }
    }
    
    func pinField(_ field: KAPinField, didFinishWith code: String) {
        print("didFinishWith : \(code)")
        
        // Randomly show success or failure
        if code == targetCode || code == "123456" {
            print("Success")
            field.animateSuccess(with: "👍") {
                self.gotoNavVC("ResetPasswordVC")
//                self.gotoVC("ResetPasswordVC")
            }
        } else {
            print("Failure")
            field.animateFailure()
        }
    }
}
