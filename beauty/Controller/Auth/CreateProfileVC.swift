//
//  CompleteProfileVC.swift
//  beauty
//
//  Created by cs on 2020/3/2.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON
import MBProgressHUD
import Kingfisher


var myAddress = ""
var myLat = 0.0
var myLng = 0.0

class CreateProfileVC: BaseViewController {

    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var imv_userPhoto: UIImageView!
    @IBOutlet weak var txt_location: UITextField!
    var hud : MBProgressHUD!
    let picker: UIImagePickerController = UIImagePickerController()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        lbl_userName.text = Defaults[\.userName]
        initData()
        
        self.picker.delegate = self
        picker.allowsEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txt_location.text = myAddress
    }
    
    func initData() {        

        if let user_photo = Defaults[\.userPhotoUrl] {
            if user_photo != "" {
                self.imv_userPhoto.kf.indicatorType = .activity
                self.imv_userPhoto.kf.setImage(with: URL(string: user_photo), placeholder: UIImage(named: "avatar"))
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        myAddress = ""
    }

    @IBAction func onClickAvatar(_ sender: Any) {
        
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
    
    @IBAction func onClickLocation(_ sender: Any) {
        
//        let mapViewVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileMapVC") as! ProfileMapVC
//        mapViewVC.previousVC = "createProfileVC"
//        mapViewVC.modalPresentationStyle = .fullScreen
////        self.present(mapViewVC, animated: true)
//        gotoNavVC("ProfileMapVC")
    }
    @IBAction func onClicklocation(_ sender: Any) {
        gotoNavVC("ProfileMapVC")
    }
    
    @IBAction func onClickNext(_ sender: Any) {
        
        let location = txt_location.text!
        let userPhoto = imv_userPhoto.image!
        if location.isEmpty {
            showToast(R.string.INPUT_LOCATION)
            return
        }
        
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        if userType == "client" {
            CustomerApiManager.addProfile(userId: Defaults[\.userId]!, address: location, latitude: myLat, longitude: myLng, file: userPhoto, completion: {(isSuccess,data) in

                if isSuccess{
                    let dict = JSON(data as Any)
                    Defaults[\.myLat] = dict[CONSTANT.USER_DATA][CONSTANT.MY_LAT].doubleValue
                    Defaults[\.myLng] = dict[CONSTANT.USER_DATA][CONSTANT.MY_LNG].doubleValue
                    Defaults[\.userLocation] = dict[CONSTANT.USER_DATA][CONSTANT.USER_ADDRESS].stringValue
                    Defaults[\.userPhotoUrl] = dict[CONSTANT.USER_DATA][CONSTANT.USER_PHOTO_URL].stringValue
                    Defaults[\.userRegistered] = true
                    self.hud.hide(animated: true)
                    self.gotoCustomerVC("HomeVC")
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
            ProviderApiManager.addProfile(userId: Defaults[\.userId]!, address: location, latitude: myLat, longitude: myLng, file: userPhoto, completion: {(isSuccess,data) in

                if isSuccess{
                 
                    let dict = JSON(data as Any)
                    Defaults[\.myLat] = dict[CONSTANT.USER_DATA][CONSTANT.MY_LAT].doubleValue
                    Defaults[\.myLng] = dict[CONSTANT.USER_DATA][CONSTANT.MY_LNG].doubleValue
                    Defaults[\.userPhotoUrl] = dict[CONSTANT.USER_DATA][CONSTANT.USER_PHOTO_URL].stringValue
                    Defaults[\.userLocation] = dict[CONSTANT.USER_DATA][CONSTANT.USER_ADDRESS].stringValue
                    Defaults[\.userRegistered] = true
                    self.hud.hide(animated: true)
                    self.gotoNavVC("CompleteProviderProfileVC")
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
}

//MARK:-  ImagePickerDelegate
extension CreateProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[.editedImage] as? UIImage {
            self.imv_userPhoto.image = img
        }
        
        dismiss(animated: true, completion: nil)
    }
}
