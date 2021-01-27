//
//  BaseViewController.swift
//  KiddiesAhead
//
//  Created by sts on 4/6/18.
//  Copyright © 2018 mingah. All rights reserved.
//

import UIKit
import Toast_Swift
import SwiftyUserDefaults
import MBProgressHUD
import Foundation
import FAPanels

class BaseViewController: UIViewController {

    let kColorOrange = UIColor(hex: "FDB913")
    
    override func viewDidLoad() {
        super.viewDidLoad()        

        hideKeyboardWhenTappedAround()
        // to enable swiping left when back button in navigation bar customized
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isValidEmail(email:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
        
    }    

    func showAlertDialog(title: String!, message: String!, positive: String?, negative: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if (positive != nil) {
            
            alert.addAction(UIAlertAction(title: positive, style: .default, handler: nil))
        }
        
        if (negative != nil) {
            
            alert.addAction(UIAlertAction(title: negative, style: .default, handler: nil))
        }
        
        DispatchQueue.main.async(execute:  {
            self.present(alert, animated: true, completion: nil)
        })
    }

    func showError(_ message: String!) {

        showAlertDialog(title: "", message: message, positive:"OK", negative: nil)
    }

    func showAlert(_ message: String!) {
        showAlertDialog(title: "", message: message, positive: "OK", negative: nil)
    }
   
    
    func showToast(_ message : String) {
        self.view.makeToast(message)
    }
    
    func showToast(_ message : String, duration: TimeInterval = ToastManager.shared.duration, position: ToastPosition = .center) {
    
        self.view.makeToast(message, duration: duration, position: position)
    }
    
    func gotoNavVC (_ nameVC: String) {
        
        let toVC = self.storyboard?.instantiateViewController( withIdentifier: nameVC)
        toVC!.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(toVC!, animated: true)
    }
    
    func doDismiss(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func gotoVC(_ nameVC: String){
        
        let toVC = self.storyboard?.instantiateViewController( withIdentifier: nameVC)
        toVC!.modalPresentationStyle = .fullScreen
        self.present(toVC!, animated: false, completion: nil)
    }
    
    func gotoCustomerVC(_ gotoVC: String) {
        
        let mainVC : UIViewController
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC: MenuVC = mainStoryboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        if gotoVC == "HomeVC" {
            mainVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        } else if gotoVC == "BookingHistoryVC" {
            mainVC = mainStoryboard.instantiateViewController(withIdentifier: "BookingHistoryVC") as! BookingHistoryVC
        } else if gotoVC == "MessageListVC" {
            mainVC = mainStoryboard.instantiateViewController(withIdentifier: "MessageListVC") as! MessageListVC
        }else {
            mainVC = mainStoryboard.instantiateViewController(withIdentifier: "CompleteProfileVC") as! CompleteProfileVC
        }
        
        let centerNavVC = UINavigationController(rootViewController: mainVC)
        
        let rootController = FAPanelController()
        _ = rootController.center(centerNavVC).left(menuVC)
        rootController.leftPanelPosition = .front
        rootController.modalPresentationStyle = .fullScreen
        self.present(rootController, animated: true, completion: nil)
    }
    
   func gotoProviderVC(_ gotoVC: String) {
        
        let mainVC : UIViewController
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC: ProviderMenuVC = mainStoryboard.instantiateViewController(withIdentifier: "ProviderMenuVC") as! ProviderMenuVC
        if gotoVC == "MessageVC" {
            mainVC = mainStoryboard.instantiateViewController(withIdentifier: "MessageListVC") as! MessageListVC
        } else if gotoVC == "ProviderHomeVC" {
            mainVC = mainStoryboard.instantiateViewController(withIdentifier: "ProviderHomeVC") as! ProviderHomeVC
        } else if gotoVC == "MembershipVC" {
            mainVC = mainStoryboard.instantiateViewController(withIdentifier: "MembershipVC") as! MembershipVC
        } else if gotoVC == "BookingHistoryVC" {
            mainVC = mainStoryboard.instantiateViewController(withIdentifier: "BookingHistoryVC") as! BookingHistoryVC
        } else if gotoVC == "ChangeServiceVC" {
            mainVC = mainStoryboard.instantiateViewController(withIdentifier: "ChangeServiceVC") as! ChangeServiceVC
        } else  {
            mainVC = mainStoryboard.instantiateViewController(withIdentifier: "CompleteProfileVC") as! CompleteProfileVC
        }
    
        let centerNavVC = UINavigationController(rootViewController: mainVC)
        
        let rootController = FAPanelController()
        _ = rootController.center(centerNavVC).left(menuVC)
        rootController.leftPanelPosition = .front
        rootController.modalPresentationStyle = .fullScreen
        self.present(rootController, animated: false, completion: nil)
    }
    
    //set dispaly effect
    func setTransitionType(_ direction : CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = direction
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.linear)
        
        view.window!.layer.add(transition, forKey: kCATransition)
    }
    
    func progressHUD(view : UIView, mode: MBProgressHUDMode = .annularDeterminate) -> MBProgressHUD {
    
    let hud = MBProgressHUD .showAdded(to:view, animated: true)
    hud.mode = mode
    hud.label.text = "Loading";
    hud.animationType = .zoomIn
    hud.tintColor = UIColor.white
    hud.contentColor = kColorOrange
    return hud
    }
    
    func gotoMainVC() {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC: MenuVC = mainStoryboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        let mainVC: HomeVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let centerNavVC = UINavigationController(rootViewController: mainVC)
        
        //  Case 1: With Code only approah
        let rootController = FAPanelController()
        
        //  Case 2: With Xtoryboards, Xibs And NSCoder
        //        let rootController: FAPanelController = window?.rootViewController as! FAPanelController
        
        rootController.configs.leftPanelWidth = 100
        rootController.configs.bounceOnRightPanelOpen = false
        
        _ = rootController.center(centerNavVC).left(menuVC)
        //_ = rootController.center(centerNavVC).right(rightMenuVC)
        rootController.leftPanelPosition = .front
        /*rootController.rightPanelPosition = .front
         */
        
        
        //        //  For Case 1 only
        //        window?.rootViewController = rootController
        //
        
        self.present(rootController, animated: true, completion: nil)
    }

    
//    func getReadableDate(timeStamp: TimeInterval) -> String? {
//
//    let date = Date(timeIntervalSince1970: timeStamp)
//    let dateFormatter = DateFormatter()
//
//    if Calendar.current.isDateInTomorrow(date) {
//        return "Tomorrow"
//    } else if Calendar.current.isDateInYesterday(date) {
//        return "Yesterday"
//    } else if dateFallsInCurrentWeek(date: date) {
//        if Calendar.current.isDateInToday(date) {
//            dateFormatter.dateFormat = "h:mm a"
//            return dateFormatter.string(from: date)
//        } else {
//            dateFormatter.dateFormat = "EEEE"
//            return dateFormatter.string(from: date)
//        }
//    } else {
//        dateFormatter.dateFormat = "MMM d, yyyy"
//        return dateFormatter.string(from: date)
//    }
//}
//
//func dateFallsInCurrentWeek(date: Date) -> Bool {
//    let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
//    let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
//    return (currentWeek == datesWeek)
//}
}

extension DefaultsKeys {
    
    var userEmail : DefaultsKey<String?>{ return .init("userEmail")}
    var userPwd : DefaultsKey<String?>{ return .init("userPwd")}
    var userId : DefaultsKey<Int?>{ return .init("userId")}
    var userPhotoUrl : DefaultsKey<String?>{ return .init("userPhotoUrl")}
    var userGender : DefaultsKey<String?>{ return .init("userGender")}
    var userName : DefaultsKey<String?>{ return .init("userName")}
    var userPhoneNumber : DefaultsKey<String?>{ return .init("userPhoneNumber")}
    var userRegistered : DefaultsKey<Bool>{ return .init("userRegistered", defaultValue: false)}
    var userType : DefaultsKey<String?>{ return .init("userType")}
    var userLocation : DefaultsKey<String?>{ return .init("userLocation")}
    var userLoginType : DefaultsKey<String?>{ return .init("userLoginType")}
    var myLat : DefaultsKey<Double?>{ return .init("MyLat")}
    var myLng : DefaultsKey<Double?>{ return .init("MyLng")}
    var device_token : DefaultsKey<String?>{ return .init("device_token")}
    var providerMainImage : DefaultsKey<String?>{return .init("providerMainImage")}
    var userExpireMembershipDate: DefaultsKey<String?>{ return .init("userExpireMembershipDate")}
    var serviceRegistered : DefaultsKey<Int?>{return .init("serviceRegistered", defaultValue: 0)}
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }
    
    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = hex.substring(1)
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.length) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
    }
}

extension Float {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

extension String {
    /**
     :name:    trim
     */
    public var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /**
     :name:    lines
     */
    public var lines: [String] {
        return components(separatedBy: CharacterSet.newlines)
    }
    
    /**
     :name:    firstLine
     */
    public var firstLine: String? {
        return lines.first?.trimmed
    }
    
    /**
     :name:    lastLine
     */
    public var lastLine: String? {
        return lines.last?.trimmed
    }
    
    /**
     :name:    replaceNewLineCharater
     */
    public func replaceNewLineCharater(separator: String = " ") -> String {
        return components(separatedBy: CharacterSet.whitespaces).joined(separator: separator).trimmed
    }
    
    /**
     :name:    replacePunctuationCharacters
     */
    public func replacePunctuationCharacters(separator: String = "") -> String {
        return components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: separator).trimmed
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
     let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
}

