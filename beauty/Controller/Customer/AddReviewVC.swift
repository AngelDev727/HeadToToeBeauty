//
//  AddReviewVC.swift
//  beauty
//
//  Created by cs on 2020/3/7.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import Cosmos
import MBProgressHUD
import SwiftyJSON
import SwiftyUserDefaults

var rating : Double = 0
var feedback = ""

class AddReviewVC: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var reviewPhotoList: UICollectionView!
    @IBOutlet weak var addRatingView: CosmosView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var providerMainImageView: UIImageView!
    @IBOutlet weak var providerLogoImageView: UIImageView!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var providerRatingView: CosmosView!
    @IBOutlet weak var providerAddressLabel: UILabel!
    @IBOutlet weak var providerServiceNameLabel: UILabel!
    @IBOutlet weak var providerDescriptionLabel: UILabel!
    
    let picker: UIImagePickerController = UIImagePickerController()
    var providerId = 0
    var hud : MBProgressHUD!
    var serviceTypeNameString = ""
  
    var reviewPhotoData = [ReviewPhotoModel]()
    var reviewPhotos = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        rating = 0
        feedback = ""
        setNavBar()
        onCallGetProviderInfoApi()
        
        self.picker.delegate = self
        picker.allowsEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setReviewPart()
    }
    
    func setNavBar() {
        
        self.title = "Add Review"
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtton.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtton
    }
    
    func setReviewPart() {
        
        if rating == 0 {
            addRatingView.isHidden = true
            feedbackLabel.isHidden = true
        } else {
            addRatingView.isHidden = false
            feedbackLabel.isHidden = false
            addRatingView.text = "\(rating)" + "/5.0"
            addRatingView.rating = rating
            feedbackLabel.text = feedback
        }
    }
    
    func onCallGetProviderInfoApi() {
      
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        
        CustomerApiManager.getProviderInfo(provider_id: providerId, completion: {(isSuccess,data) in

            if isSuccess{
                let dict = JSON(data as Any)
                let providerInformation = dict[CONSTANT.USER_DATA]
                let provider = ProviderModel(dict:providerInformation)
                
                if provider.providerMainImageUrl != "" {
                    self.providerMainImageView.kf.indicatorType = .activity
                    self.providerMainImageView.kf.setImage(with: URL(string: provider.providerMainImageUrl), placeholder: UIImage(named: "placeholder"))
                
                }
                
                if provider.providerLogoImageUrl != "" {
                    self.providerLogoImageView.kf.indicatorType = .activity
                    self.providerLogoImageView.kf.setImage(with: URL(string: provider.providerLogoImageUrl), placeholder: UIImage(named: "avatar"))
                }
               
                self.providerRatingView.rating = provider.providerRating
                self.providerRatingView.text = "\(provider.providerRating)/5.0"
                self.providerNameLabel.text = provider.providerName
                self.providerAddressLabel.text = provider.providerAddress
                self.descriptionLabel.text = provider.providerDescription
                self.serviceTypeNameString = provider.providerServiceType
                self.providerId = provider.provider_id
                self.loadServiceTypeNameList(primaryString: self.serviceTypeNameString)
                
               
                
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
                
    //            let one = ServiceTypeListModel(serviceTypeName: CONSTANT.serviceTypeNames["\(item)"]!)
                tmp += CONSTANT.serviceTypeNames["\(item)"]! + "\n"
            }
            
            providerServiceNameLabel.text = tmp
        }
    
    @IBAction func onClickAddFeedback(_ sender: Any) {
        
        gotoNavVC("ReviewVC")
    }
    
    @IBAction func onClickAddImage(_ sender: Any) {
        
        let galleryAction = UIAlertAction(title: "From Gallery", style: .destructive) { (action) in
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "From Camera", style: .destructive) { (action) in
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler : nil)
        
        // Create and configure the alert controller.
        let alert = UIAlertController(title: "", message: "Choose Image", preferredStyle: .actionSheet)
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onClickAddReview(_ sender: Any) {
        
        if feedback == "" {
            showToast("Please input your feedback.")
            return
        }
        
        if rating == 0.0 {
            showToast("Please input your rating value.")
            return
        }
        
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        
        CustomerApiManager.addReview(
            user_id: Defaults[\.userId]!,
            provider_id: providerId,
            rating: rating,
            feedback: feedback,
            photos: reviewPhotos,
            serviceType: key,
            completion: {(isSuccess, data) in

            self.hud.hide(animated: true)
            
            if isSuccess{
                let allReviewVC = self.storyboard?.instantiateViewController(withIdentifier: "AllReviewVC") as! AllReviewVC
                allReviewVC.providerId = self.providerId
                self.navigationController?.pushViewController(allReviewVC, animated: true)
                
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
//MARK:--Collectioview Extension
extension AddReviewVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

//MARK: UICollectionViewDataSource
extension AddReviewVC : UICollectionViewDataSource{
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return reviewPhotoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewPhotoCell", for: indexPath) as! ReviewPhotoCell
        cell.entity = reviewPhotoData[indexPath.row]
        return cell
    }
}

extension AddReviewVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let h = collectionView.frame.size.height
        let w = h
        return CGSize(width: w,height: h)
    }
}

//MARK:-  ImagePickerDelegate
extension AddReviewVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[.editedImage] as? UIImage {
            self.reviewPhotoData.append(ReviewPhotoModel(imgFile: img ))
            self.reviewPhotos.append(img)
            self.reviewPhotoList.reloadData()
        }
        
        dismiss(animated: true, completion: nil)
    }
}
