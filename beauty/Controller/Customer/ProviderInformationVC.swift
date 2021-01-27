//
//  ProviderInformationVC.swift
//  beauty
//
//  Created by cs on 2020/3/5.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import Cosmos
import SwiftyJSON
import SwiftyUserDefaults
import MBProgressHUD
import Kingfisher

class ProviderInformationVC: BaseViewController {

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var providerPhotoList: UICollectionView!
    @IBOutlet weak var providerMainPhoto: UIImageView!
    @IBOutlet weak var providerLogo: UIImageView!
    @IBOutlet weak var providerRating: CosmosView!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var providerAddress: UILabel!
   
    @IBOutlet weak var serviceDescription: UILabel!
    @IBOutlet weak var providerCertification: UIImageView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var serviceTypeNameList: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var hud : MBProgressHUD!
    var providerId = 0
    var serviceTypes = [ServiceTypeListModel]()
    var serviceTypeNameString = ""
    var providerPhoneNumber = ""
    var imageUrls = [String]()
    var alamofireSources = [AlamofireSource]()
    
    var facebook_link = ""
    var instagram_link = ""
    
    
    var rowHeight: Float = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        serviceTypes.removeAll()
        initView()
    }
    
    func setNavBar() {
        
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtton.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtton
        
        if categoryStatus == 1 {
            self.title = "HAIR THERAPY"
        }else {
            self.title = "SPA THERAPY"
        }
    }
    
    func initView() {
      
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        
        CustomerApiManager.getProviderInfo(provider_id: providerId, completion: {(isSuccess,data) in

            if isSuccess{
                let dict = JSON(data as Any)
                let providerInformation = dict[CONSTANT.USER_DATA]
                let provider = ProviderModel(dict:providerInformation)
                
                self.providerMainPhoto.kf.indicatorType = .activity
                self.providerMainPhoto.kf.setImage(with: URL(string: provider.providerMainImageUrl), placeholder: UIImage(named: "placeholder"))
                
                self.providerLogo.kf.indicatorType = .activity
                self.providerLogo.kf.setImage(with: URL(string: provider.providerLogoImageUrl), placeholder: UIImage(named: "avatar"))
                
                self.providerCertification.kf.indicatorType = .activity
                self.providerCertification.kf.setImage(with: URL(string: provider.providerCertificationImageUrl), placeholder: UIImage(named: "placeholder"))
                
                self.providerRating.rating = provider.providerRating
                self.providerRating.text = "\(provider.providerRating)/5.0"
                self.providerName.text = provider.business_name
                self.providerAddress.text = provider.providerAddress
                self.phoneButton.setTitle(provider.providerPhoneNumber, for: .normal) 
                self.providerPhoneNumber = provider.providerPhoneNumber
                self.serviceDescription.text = provider.providerDescription
                self.serviceTypeNameString = provider.providerServiceType
                self.providerId = provider.provider_id
                self.loadServiceTypeNameList(primaryString: self.serviceTypeNameString)
                
                self.getImageDatas(datas: dict)
                
                self.facebook_link = provider.facebook_link
                self.instagram_link = provider.instagram_link
                
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
    
    func getImageDatas(datas: JSON) {
        
        let tmp = datas["images"].arrayValue
        for one in tmp {
            imageUrls.append(one.stringValue)
        }
        
        self.setSlideShow()
    }
    
    func setSlideShow() {
        
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.clear
        pageControl.pageIndicatorTintColor = UIColor.clear
        slideshow.pageIndicator = pageControl
        
        
        slideshow.activityIndicator = DefaultActivityIndicator()
        
        slideshow.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .customBottom(padding: 10))
        slideshow.delegate = self
        
        alamofireSources.removeAll()
        for item in imageUrls {
            let tmp = AlamofireSource(urlString: item)!
            alamofireSources.append(tmp)
        }
        
        slideshow.setImageInputs(alamofireSources)
        

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(`ProviderInformationVC`.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    func loadServiceTypeNameList(primaryString: String) {
        
        var tmp = ""
        let serviceTypeIds = primaryString.split(separator: ",")
        
        for item in serviceTypeIds {
            
            let one = ServiceTypeListModel(index: "", serviceTypeName: CONSTANT.serviceTypeNames["\(item)"]!, selected: false )
            serviceTypes.append(one)
            tmp += CONSTANT.serviceTypeNames["\(item)"]! + "\n"
        }
        
        let rowCount = serviceTypes.count / 2 > 0 ? serviceTypes.count / 2 + 1 : serviceTypes.count
        collectionViewHeight.constant = CGFloat(Float(rowCount) * (rowHeight + 10.0))
        self.serviceTypeNameList.layoutIfNeeded()
        serviceTypeNameList.reloadData()
    }
    
    @IBAction func onClickAddReview(_ sender: Any) {
        
        let addReviewVC = self.storyboard?.instantiateViewController(withIdentifier: "AddReviewVC") as! AddReviewVC
        addReviewVC.providerId = providerId
        self.navigationController?.pushViewController(addReviewVC, animated: true)
    }
    @IBAction func onClickViewDetail(_ sender: Any) {
        
        let allReviewVC = self.storyboard?.instantiateViewController(withIdentifier: "AllReviewVC") as! AllReviewVC
        allReviewVC.providerId = providerId
        self.navigationController?.pushViewController(allReviewVC, animated: true)
    }
    
    
    @IBAction func onClickChat(_ sender: Any) {
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.providerId = providerId
        chatVC.providerName = providerName.text!
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @IBAction func onClickPhone(_ sender: Any) {
       phoneCall()
    }
    
    func phoneCall() {
        let phoneNumber = Int(providerPhoneNumber)!
        if phoneNumber != 0 {
            if let url = URL(string: "tel://\(String(describing: phoneNumber))"),
            UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    // Fallback on earlier versions                   
                }
            }
        }
    }
    
    @IBAction func onClickViewAppointment(_ sender: Any) {
        
        let scheduleVC = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleVC") as! ScheduleVC
        scheduleVC.providerId = providerId
        scheduleVC.providerName = providerName.text!
   
        self.navigationController?.pushViewController(scheduleVC, animated: true)
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
extension ProviderInformationVC: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
}

//MARK:--Collectioview Extension
extension ProviderInformationVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

//MARK: UICollectionViewDataSource
extension ProviderInformationVC : UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceTypeCell", for: indexPath) as! ServiceTypeCell
        cell.entity = serviceTypes[indexPath.row]
        return cell
    }
}

extension ProviderInformationVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = collectionView.frame.size.width/2 - 6
        return CGSize(width: w,height: CGFloat(rowHeight))
    }
    
}


