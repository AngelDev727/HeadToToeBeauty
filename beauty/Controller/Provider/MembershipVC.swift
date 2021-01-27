//
//  MembershipVC.swift
//  beauty
//
//  Created by cs on 2020/3/9.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import FAPanels
import SwiftyUserDefaults
import MBProgressHUD

class MembershipVC: BaseViewController {
    
    var membership_type = 0
    
    var hud : MBProgressHUD!
    fileprivate var paypalEnvironment: String = /*PayPalEnvironmentProduction*/ PayPalEnvironmentSandbox  {
        willSet (newEnviroment) {
            if newEnviroment != paypalEnvironment {
                PayPalMobile.preconnect(withEnvironment: newEnviroment)
            }
        }
    }
    //    fileprivate var paypalConfig = PayPalConfiguration()
    var paypalResultText = ""
    var paypalConfig = PayPalConfiguration()

    var providerMenuVC : ProviderMenuVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        configurationPaypal()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PayPalMobile.preconnect(withEnvironment: paypalEnvironment)
    }
    func setNavBar() {
        
        self.title = "MEMERSHIP PLAN"
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtton.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtton
    }
    
    fileprivate func configurationPaypal() {
           
        #if HAS_CARDIO
         // You should use the PayPal-iOS-SDK+card-Sample-App target to enable this setting.
         // For your apps, you will need to link to the libCardIO and dependent libraries. Please read the README.md
         // for more details.
         paypalConfig.acceptCreditCards = true
        #else
         paypalConfig.acceptCreditCards = false
        #endif
        paypalConfig.merchantName = Defaults[\.userName]
        paypalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        paypalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        paypalConfig.languageOrLocale = Locale.preferredLanguages[0]
        paypalConfig.payPalShippingAddressOption = .payPal
    }
    
    @IBAction func onPayClick(_ sender: UIButton) {
        
        if sender.tag == 0 {
            membership_type = 1
        } else {
            membership_type = 3
        }
        
        payWithPayPal()
    }
    func payWithPayPal() {
        
        var cost = 15
        if membership_type == 3 {
            cost = 40
        }
        
        let donateDescription = "Membership plan";
        let paypalPayment = PayPalPayment(amount: NSDecimalNumber(value: cost), currencyCode: "USD", shortDescription: donateDescription, intent: .order)
        
        if paypalPayment.processable {
            let paymentVC = PayPalPaymentViewController(payment: paypalPayment, configuration: paypalConfig, delegate: self)!
            self.present(paymentVC, animated: true, completion: nil)
        } else {
            self.showAlertDialog(title: "PayPal Error!", message: "Something went wrong, Please try again later", positive: "OK", negative: nil)
        }
    }
    
    @IBAction func onClickMenu(_ sender: Any) {
        panel?.openLeft(animated: true)
    }
    
    func onCallPayMembershipApi() {
        
        let paydate =  getCurrentTimeStamp()
        
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        ProviderApiManager.payMembership(provider_id: Defaults[\.userId]!, pay_date: Int(paydate), membership_type: self.membership_type, completion: {(isSuccess, data) in
            
            if (isSuccess){
                self.hud.hide(animated: true)
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
    
}

extension MembershipVC: PayPalPaymentDelegate {
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        
        paymentViewController.dismiss(animated: true, completion: nil)
        //self.showAlertDialog(title: "Canceled", message: "You have canceled payment transaction.", positive: Const.OK, negative: nil)
        
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("didComplete", completedPayment)
        
        
        paymentViewController.dismiss(animated: true, completion: nil)
        // TODO: Change transaction id
        let transactionId = (completedPayment.confirmation["response"] as! [AnyHashable: Any])["id"] as! String
        
        print("didComplete with : \(transactionId)")
        
        //add_order(transactionId)
        
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, willComplete completedPayment: PayPalPayment, completionBlock: @escaping PayPalPaymentDelegateCompletionBlock) {
        paymentViewController.dismiss(animated: true, completion: nil)
        print("willComplete", completedPayment)
        
        let transactionId = (completedPayment.confirmation["response"] as! [AnyHashable: Any])["id"] as! String
        
        print("willComplete with : \(transactionId)")
        self.showAlert("Payment is completed with transaction ID: \(transactionId)")
        onCallPayMembershipApi()
    }
}

