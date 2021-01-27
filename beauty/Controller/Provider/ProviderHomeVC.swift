//
//  ProviderHomeVC.swift
//  beauty
//
//  Created by cs on 2020/3/8.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import FAPanels
import SwiftyJSON
import SwiftyUserDefaults
import MBProgressHUD
import Kingfisher

class ProviderHomeVC: BaseViewController {

    var providerMenuVC : ProviderMenuVC!
    var serviceNameDataSource = [ProviderServiceListModel]()
    var serviceNames = ["HAIR CUT", "HAIR TEXTURE", "MANICURE", "HAIR REMOVAL"]
    var hud : MBProgressHUD!
    var serviceIdsString = ""
    
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var notificationNumLabel: UILabel!
    @IBOutlet weak var providerImages: UIImageView!
    @IBOutlet weak var providerLogoImageView: UIImageView!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var providerAddressLabel: UILabel!
    @IBOutlet weak var serviceNamesLabel: UILabel!
    @IBOutlet weak var providerMembershipDateLabel: UILabel!
    @IBOutlet weak var emptyMembershipLabel: UILabel!
    @IBOutlet weak var MembershipLabel: UILabel!
    @IBOutlet weak var ServiceNameList: DynamicHeightCollectionView!
    @IBOutlet weak var lblMembershipState: UILabel!
    
    @IBOutlet weak var butFaceBook: UIButton!
    @IBOutlet weak var butInstagram: UIButton!
    
    
    var serviceTypes = [ServiceTypeListModel]()
    var facebook_link = ""
    var instagram_link = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.notificationButton.isHidden = true
        self.notificationNumLabel.isHidden = true
        
        viewConfigurations()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        serviceTypes.removeAll()
        
        if Defaults[\.userRegistered] {
            getUnreadMessageCount()
            onCallGetInformtaionApi()           
        }
        
        showButtonFaceBookAndInstagram()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtton.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtton
       
    }
    
    func showButtonFaceBookAndInstagram () {
        if facebook_link == "" {
            butFaceBook.isHidden = true
        } else {
            butFaceBook.isHidden = false
        }
        
        if instagram_link == "" {
            butInstagram.isHidden = true
        } else {
            butInstagram.isHidden = false
        }
    }
    
    func viewConfigurations() {

        panel!.configs = FAPanelConfigurations()
        panel?.leftPanelPosition = .front //.back
        panel!.configs.panFromEdge = false
        panel!.configs.minEdgeForLeftPanel = 40 //CGFloat(Double(sliderValueAsText)!)
        panel!.configs.centerPanelTransitionDuration = 1 //TimeInterval(Double(valueAsText)!)
        panel!.configs.leftPanelWidth = 150
        panel!.configs.canLeftSwipe = true

        let animOptions: FAPanelTransitionType = .moveLeft
        panel!.configs.centerPanelTransitionType = animOptions
        panel!.configs.bounceOnRightPanelOpen = false
        panel!.configs.bounceDuration = 0.1

        panel!.delegate = self
    }
    
    func getUnreadMessageCount() {
        
        CommonApiManager.getUnreadMessageCount(user_id: Defaults[\.userId]!, user_type: userType, completion: {(isSuccess, data) in
            
            if (isSuccess){
                
                let dict = JSON(data as Any)
                let badgeCount = dict["count"].stringValue
                self.notificationNumLabel.text = badgeCount
                if badgeCount == "0" {
                    self.notificationButton.isHidden = true
                    self.notificationNumLabel.isHidden = true
                }else {
                    self.notificationNumLabel.isHidden = false
                    self.notificationButton.isHidden = false
                }
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
            }
        })
    }
    
    func onCallGetInformtaionApi() {
        
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        
        CustomerApiManager.getProviderInfo(provider_id: Defaults[\.userId]!, completion: {(isSuccess,data) in

            if isSuccess{
                let dict = JSON(data as Any)
                let providerInformation = dict[CONSTANT.USER_DATA]
                let provider = ProviderModel(dict:providerInformation)
                Defaults[\.userPhotoUrl] = provider.providerImage
                
                if provider.providerMainImageUrl != "" {
                    self.providerImages.kf.indicatorType = .activity
                    self.providerImages.kf.setImage(with: URL(string: provider.providerMainImageUrl), placeholder: UIImage(named: "placeholder"))
                }
                
                if provider.providerLogoImageUrl != "" {
                    self.providerLogoImageView.kf.indicatorType = .activity
                    self.providerLogoImageView.kf.setImage(with: URL(string: provider.providerLogoImageUrl), placeholder: UIImage(named: "avatar"))
                }
                
                self.providerNameLabel.text = provider.business_name
                
                self.providerAddressLabel.text = provider.providerAddress
                self.serviceIdsString = provider.providerServiceType
                self.loadServiceTypeNameList(primaryString: self.serviceIdsString)
                self.facebook_link = provider.facebook_link
                self.instagram_link = provider.instagram_link
                
                self.showButtonFaceBookAndInstagram()
                
                if provider.membership_state == "not_paid" {
                    
                    self.lblMembershipState.text = "NO MEMBERSHIP"
                    self.MembershipLabel.text = "You don't have memership plan"
                    
                } else if provider.membership_state == "trial" {
                    self.lblMembershipState.text = "FREE TRIAL"
                    self.MembershipLabel.text = "Expires on " + "\(provider.exptime)"
                    Defaults[\.userExpireMembershipDate] = provider.exptime
                    
                } else if provider.membership_state == "live" {
                    
                    if provider.membership_type == 1 {
                        self.lblMembershipState.text = "BASIC MEMBERSHIP"
                        self.MembershipLabel.text = "Expires on " + "\(provider.exptime)"
                    } else {
                        self.lblMembershipState.text = "PREMIUM MEMBERSHIP"
                        self.MembershipLabel.text = "Expires on " + "\(provider.exptime)"
                    }
                    
                } else {
                    self.lblMembershipState.text = "EXPIRED"
                    self.MembershipLabel.text = "Your membership is expired"
                }
                
                Provider = provider
                self.hud.hide(animated: true)
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
    
    func loadServiceTypeNameList(primaryString: String) {
            
            var tmp = ""
            let serviceTypeIds = primaryString.split(separator: ",")
            
            for item in serviceTypeIds {
   
                let one = ServiceTypeListModel(index: "", serviceTypeName: CONSTANT.serviceTypeNames["\(item)"]!, selected: false )
                serviceTypes.append(one)
                tmp += CONSTANT.serviceTypeNames["\(item)"]! + "\n"
            }
            ServiceNameList.reloadData()
            serviceNamesLabel.text = tmp
        }
    
    
    
    @IBAction func onClickMenu(_ sender: Any) {
        panel?.openLeft(animated: true)        
    }
    
    @IBAction func onClickNotification(_ sender: Any) {
        
        gotoNavVC("MessageListVC")
    }
    
    @IBAction func onClickFacebook(_ sender: Any) {
        if let url = URL(string: self.facebook_link) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func onClickInstagram(_ sender: Any) {
        if let url = URL(string: self.instagram_link) {
            UIApplication.shared.open(url)
        }
    }
    
}
//MARK:--TableView Delegate
extension ProviderHomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK: TableViewDataSource
extension ProviderHomeVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceNameDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProviderServiceListCell", for: indexPath) as! ProviderServiceListCell
        cell.entity = serviceNameDataSource[indexPath.row]
        return cell
    }
}
//MARK:--FAPanel extension
extension ProviderHomeVC: FAPanelStateDelegate {
    
    func centerPanelWillBecomeActive() {
        print("centerPanelWillBecomeActive called")
    }
    
    func centerPanelDidBecomeActive() {
        print("centerPanelDidBecomeActive called")
    }
    
    
    func leftPanelWillBecomeActive() {
        print("leftPanelWillBecomeActive called")
    }
    
    
    func leftPanelDidBecomeActive() {
        print("leftPanelDidBecomeActive called")
    }
    
    
    func rightPanelWillBecomeActive() {
        print("rightPanelWillBecomeActive called")
    }
    
    func rightPanelDidBecomeActive() {
        print("rightPanelDidBecomeActive called")
    }    
}

//MARK: UICollectionViewDataSource
extension ProviderHomeVC : UICollectionViewDataSource{
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return serviceTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceTypeCell", for: indexPath) as! ServiceTypeCell
        cell.entity = serviceTypes[indexPath.row]
        return cell
    }
}

extension ProviderHomeVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = collectionView.frame.size.width/2 - 6
        return CGSize(width: w,height: 30)
    }
    
}


