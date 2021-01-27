//
//  CompleteProfileVC.swift
//  beauty
//
//  Created by cs on 2020/3/2.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import SKCountryPicker
import SwiftyUserDefaults
import Kingfisher
import SwiftyJSON
import MBProgressHUD
import iOSDropDown

class CompleteProfileVC: BaseViewController {

    @IBOutlet weak var img_userPhoto: UIImageView!
    @IBOutlet weak var txt_mail: UITextField!
    @IBOutlet weak var txt_phoneNumber: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_location: UITextField!
    @IBOutlet weak var img_flag: UIImageView!
    @IBOutlet weak var btn_dialCode: UIButton!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_authenticated: UILabel!
    @IBOutlet weak var paypalView: UIView!
    @IBOutlet weak var txtGender: DropDown!
    
    var hud : MBProgressHUD!
    var countryCode = "+1"
    let picker: UIImagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        self.picker.delegate = self
        picker.allowsEditing = true
        
        initView()
        
        if userType == "client" {
            paypalView.isHidden = true
        }else {
            paypalView.isHidden = false
        }
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if myAddress != "" {
            txt_location.text = myAddress
        }
        
        setNavBar()
        setGenderDropDown()
   
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func initView() {
        
        if Defaults[\.userPhotoUrl] != "" {
            img_userPhoto.kf.indicatorType = .activity
            img_userPhoto.kf.setImage(with: URL(string: Defaults[\.userPhotoUrl]!), placeholder: UIImage(named: "placeholder"))
        }
        
        txt_password.text = Defaults[\.userPwd]
        txt_mail.text = Defaults[\.userEmail]
        lbl_userName.text = Defaults[\.userName]
        txt_location.text = Defaults[\.userLocation]
        txtGender.text = Defaults[\.userGender]
        
        guard let country = CountryManager.shared.currentCountry else {
            self.btn_dialCode.setTitle("Pick Country", for: .normal)
            self.img_flag.isHidden = true
            return
        }
        
        btn_dialCode.setTitle(country.dialingCode, for: .normal)
        countryCode = country.dialingCode!
        if let phone_no = Defaults[\.userPhoneNumber] {
            let phoneNumber = phone_no
            txt_phoneNumber.text = String(phoneNumber)
        }
        
        img_flag.image = country.flag
        btn_dialCode.clipsToBounds = true
    }
    
    func setGenderDropDown() {
        
        txtGender.optionArray = ["Male", "Female", "I chose not to say"]
        txtGender.isSearchEnable = false
        txtGender.selectedRowColor = .clear
        txtGender.rowHeight = 40
        txtGender.checkMarkEnabled = true
        txtGender.arrowColor = .white
        txtGender.didSelect(completion: { (selected, index, id)  in
            self.txtGender.text = selected
        })
    }
    
    func setNavBar() {
        
        self.title = "Profile"
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtton.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtton
    }
    
    @IBAction func onClickEditGender(_ sender: Any) {
        txtGender.isHidden = false
        txtGender.isUserInteractionEnabled = true
    }
    
    @IBAction func onClickEmailEdit(_ sender: Any) {
        
        txt_mail.isUserInteractionEnabled = true
        txt_mail.becomeFirstResponder()
    }
    
    @IBAction func onClickPhoneNumberEdit(_ sender: Any) {
        
        txt_phoneNumber.isUserInteractionEnabled = true
        btn_dialCode.isUserInteractionEnabled = true
        txt_phoneNumber.becomeFirstResponder()
    }
    
    @IBAction func onClickCountryCode(_ sender: Any) {
        
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in

            guard let self = self else { return }
            self.countryCode = country.dialingCode!
            self.img_flag.image = country.flag
            self.btn_dialCode.setTitle(country.dialingCode, for: .normal)
        }
        // can customize the countryPicker here e.g font and color
        countryController.detailColor = UIColor.red
        CountryManager.shared.addFilter(.countryCode)
        CountryManager.shared.addFilter(.countryDialCode)
    }
    
    @IBAction func onClickPasswordEdit(_ sender: Any) {
        
        txt_password.isUserInteractionEnabled = true
        txt_password.becomeFirstResponder()
    }
    
    @IBAction func onClickLocationEdit(_ sender: Any) {
        
        txt_location.isUserInteractionEnabled = true
        //txt_location.becomeFirstResponder()
        //gotoNavVC("ProfileMapVC")
        let toVC = self.storyboard?.instantiateViewController( withIdentifier: "ProfileMapVC")
        
        self.navigationController?.pushViewController(toVC!, animated: true)
        
    }
    
    @IBAction func onClickMenu(_ sender: Any) {
        panel?.openLeft(animated: true)
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
    
    @IBAction func onClickName(_ sender: Any) {
        
        let alert = UIAlertController(title: "Input new name", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .alert
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Please input your name."
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            let newName = alert.textFields![0].text!
            self.changeUserName(newName: newName)}))
        alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: nil))

        DispatchQueue.main.async(execute:  {
         self.present(alert, animated: true, completion: nil)
        })
    }
    
    func changeUserName(newName: String) {
        
        lbl_userName.text = newName
    }
    
    @IBAction func onClickPaymentCancel(_ sender: Any) {
        lbl_authenticated.isHidden = true
    }
    
    @IBAction func onClickConfirm(_ sender: Any) {
        
        let userName = lbl_userName.text!
        let userPhoto = img_userPhoto.image!
        let phoneNumber = txt_phoneNumber.text!
        let password = txt_password.text!
        let address = txt_location.text!
        let gender = txtGender.text!
     
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        
        if userType == "client" {
            CustomerApiManager.updateProfile(userId: Defaults[\.userId]!, userName: userName, userPhoto: userPhoto, phoneNumber: phoneNumber, password: password, address: address, gender: gender, completion:  {(isSuccess, data) in
            
                if (isSuccess){
                    let userData = JSON(data as Any)
                    let dict = userData[CONSTANT.USER_DATA]
                    let user_id = dict[CONSTANT.USER_ID].intValue
                    let user_name = dict[CONSTANT.USER_NAME].stringValue
                    let phoneNumber = dict[CONSTANT.USER_PHONE_NUMBER].stringValue
                    let myLat = dict[CONSTANT.MY_LAT].doubleValue
                    let myLng = dict[CONSTANT.MY_LNG].doubleValue
                    let userPhotoUrl = dict[CONSTANT.USER_PHOTO_URL].stringValue
                    let userLocation = dict[CONSTANT.USER_ADDRESS].stringValue
                    Defaults[\.userId] = user_id
                    Defaults[\.userName] = user_name
                    Defaults[\.userPwd] = password
                    Defaults[\.userPhoneNumber] = phoneNumber
                    Defaults[\.userPhotoUrl] = userPhotoUrl
                    Defaults[\.userLocation] = userLocation
                    Defaults[\.userRegistered] = true
                    Defaults[\.myLat] = myLat
                    Defaults[\.myLng] = myLng
                    Defaults[\.serviceRegistered] = 1
                    Defaults[\.userGender] = gender
                   
                    self.hud.hide(animated: true)
                    self.showToast(R.string.SUCCESS)
                    
                }else{
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
            ProviderApiManager.updateProfile(providerId: Defaults[\.userId]!, userName: userName, userPhoto: userPhoto, phoneNumber: phoneNumber, password: password, address: address, gender: gender, completion: {(isSuccess, data) in
            
                if (isSuccess){
                    let userData = JSON(data as Any)
                    let dict = userData[CONSTANT.USER_DATA]
                    let user_id = dict[CONSTANT.USER_ID].intValue
                    let user_name = dict[CONSTANT.USER_NAME].stringValue
                    let phoneNumber = dict[CONSTANT.USER_PHONE_NUMBER].stringValue
                    let myLat = dict[CONSTANT.MY_LAT].doubleValue
                    let myLng = dict[CONSTANT.MY_LNG].doubleValue
                    let userPhotoUrl = dict[CONSTANT.USER_PHOTO_URL].stringValue
                    let userLocation = dict[CONSTANT.USER_ADDRESS].stringValue
                    Defaults[\.userId] = user_id
                    Defaults[\.userName] = user_name
                    Defaults[\.userPwd] = password
                    Defaults[\.userPhoneNumber] = phoneNumber
                    Defaults[\.userPhotoUrl] = userPhotoUrl
                    Defaults[\.userLocation] = userLocation
                    Defaults[\.userRegistered] = true
                    Defaults[\.myLat] = myLat
                    Defaults[\.myLng] = myLng
                    Defaults[\.serviceRegistered] = 1
                   
                    self.hud.hide(animated: true)
                    self.showToast(R.string.SUCCESS)
                    
                }else{
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
extension CompleteProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[.editedImage] as? UIImage {
            img_userPhoto.image = img
        }
        
        dismiss(animated: true, completion: nil)
    }
}
