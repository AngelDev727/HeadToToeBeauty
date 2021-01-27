//
//  ProviderMenuVC.swift
//  beauty
//
//  Created by cs on 2020/3/9.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Kingfisher

class ProviderMenuVC: BaseViewController {

    @IBOutlet weak var registerServiceView: UIView!
    @IBOutlet weak var img_userPhoto: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_userName.text = Defaults[\.userName]
        img_userPhoto.kf.indicatorType = .activity
        img_userPhoto.kf.setImage(with: URL(string: Defaults[\.userPhotoUrl]!), placeholder: UIImage(named: "avatar"))
        
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
    
    @IBAction func onClickMembership(_ sender: Any) {
        gotoProviderVC("MembershipVC")
    }
    
    @IBAction func onClickMyService(_ sender: Any) {
        gotoProviderVC("ProviderHomeVC")
    }
    
    @IBAction func onClickAllBooking(_ sender: Any) {
        gotoProviderVC("BookingHistoryVC")
    }
    
    @IBAction func onClickMessage(_ sender: Any) {
        gotoProviderVC("MessageVC")
    }
    @IBAction func onClickProfile(_ sender: Any) {
        gotoProviderVC("CompleteProfileVC")
    }
    @IBAction func onClickChangeService(_ sender: Any) {
        
        gotoProviderVC("ChangeServiceVC")
    }
    
    
    @IBAction func onClickLogout(_ sender: Any) {
        Defaults[\.userRegistered] = false
        Defaults[\.userPhotoUrl] = ""
        
        let loginNavVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNav") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = loginNavVC
        
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
//        Defaults.removeAll()
    }
}
