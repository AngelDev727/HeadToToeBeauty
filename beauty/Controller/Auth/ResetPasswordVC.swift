//
//  ResetPasswordVC.swift
//  beauty
//
//  Created by cs on 2020/3/19.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import KAPinField
import SwiftyUserDefaults
import SwiftyJSON
import MBProgressHUD

class ResetPasswordVC: BaseViewController {

    @IBOutlet weak var txf_password: UITextField!
    @IBOutlet weak var txf_confirmPassword: UITextField!
    @IBOutlet weak var lblUserType: UILabel!
    var user_id = 0
    var hud : MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblUserType.text = "(" + userType.prefix(1).uppercased() + userType.dropFirst() + ")"
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onClickReset(_ sender: Any) {
        
        if txf_password.text == "" {
            showToast("Please input new password.")
            return
        } else if txf_password.text != txf_confirmPassword.text {
            showToast("Please input vaild confirm password.")
            return
        }
        
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        CommonApiManager.resetPassword(user_id: Defaults[\.userId]!, user_type: userType, password: txf_password.text!,  completion: {(isSuccess, data) in
            if (isSuccess){
                self.gotoVC("LoginNav")
            }else{
               if data == nil {
                   self.showToast("Failed to connect to server", duration: 2, position: .bottom)
               } else {
                   let result = data as! String
                   if result == "fail" {
                       self.showToast("Your request has fail.", duration: 2, position: .bottom)
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
