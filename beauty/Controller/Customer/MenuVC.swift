//
//  MenuVC.swift
//  beauty
//
//  Created by cs on 2020/3/3.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class MenuVC: BaseViewController {

    @IBOutlet weak var img_userPhoto: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbl_userName.text = Defaults[\.userName]
        
        img_userPhoto.kf.indicatorType = .activity
        img_userPhoto.kf.setImage(with: URL(string: Defaults[\.userPhotoUrl]!), placeholder: UIImage(named: "avatar"))
        
    }
    
    @IBAction func onClickService(_ sender: Any) {
        gotoCustomerVC("HomeVC")
    }
    
    @IBAction func onClickBooking(_ sender: Any) {
        
        gotoCustomerVC("BookingHistoryVC")
    }
    @IBAction func onClickMeassage(_ sender: Any) {
        
        gotoCustomerVC("MessageListVC")
    }
    
    @IBAction func onClickProfile(_ sender: Any) {
        gotoCustomerVC("CompleteProfileVC")
    }
    @IBAction func onClickLogout(_ sender: Any) {        
 
        Defaults[\.userRegistered] = false
        Defaults[\.userPhotoUrl] = ""        
        
        let loginNavVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNav") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = loginNavVC
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
        
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
//        Defaults.removeAll()
    }
    
    
    func gotoMenuVC(_ vcName: String) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let centerVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: vcName)
        let centerNavVC = UINavigationController(rootViewController: centerVC)
        
        panel!.configs.bounceOnCenterPanelChange = true
        
        panel!.center(centerNavVC, afterThat: {
            print("Executing block after changing center panelVC From Left Menu")
        })
    }
}

