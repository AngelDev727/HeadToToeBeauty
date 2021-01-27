//
//  CompleteProviderProfileVC.swift
//  beauty
//
//  Created by cs on 2020/3/8.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import iOSDropDown
import SwiftyJSON
import SwiftyUserDefaults
import MBProgressHUD
import Kingfisher


class CompleteProviderProfileVC: BaseViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addImageLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var addLogoButton: UIButton!
    @IBOutlet weak var addLogoLabel: UILabel!
    @IBOutlet weak var certificationImageView: UIImageView!
    @IBOutlet weak var certificationButton: UIButton!
    @IBOutlet weak var certificationLabel: UILabel!
    @IBOutlet weak var service1Field: UITextField!
    @IBOutlet weak var lblSelectedServices: UILabel!
    @IBOutlet weak var travelServiceSwitchBtn: UISwitch!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var serviceList: UITableView!
    @IBOutlet weak var serviceView: UIView!
    @IBOutlet weak var tfFacebook: UITextField!
    @IBOutlet weak var tfInstagram: UITextField!
    @IBOutlet weak var tfBusinessName: UITextField!
    
    let picker: UIImagePickerController = UIImagePickerController()
    var selectedIndex = 0
    var serviceId = ""
    var selectedServiceNames = ""
    var hud : MBProgressHUD!
    var serviceTypeData = [ServiceTypeListModel]()
    var serviceNames = ["10" : "Hair cut",
                        "11" : "Hair color",
                        "12" : "Styling & finishing",
                        "13" : "Hair texture",
                        "14" : "Hair treatments",
                        "15" : "Hair men's services",

                        "20" : "Manicure",
                        "21" : "Pedicure",
                        "22" : "Artificial nails",
                        "23" : "Hair removal",
                        "24" : "Lash extension",
                        "25" : "Makeup",
                        "26" : "Skin & body"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategoryList()
        self.picker.delegate = self
        picker.allowsEditing = true
    }
    
    func loadCategoryList() {
        
        for item in serviceNames {
            
            let one = ServiceTypeListModel(index: "\(item.key)", serviceTypeName: "\(item.value)", selected: false)
            serviceTypeData.append(one)
        }
        serviceList.reloadData()
    }
    
    @IBAction func onClickAddButton(_ sender: UIButton) {
        selectedIndex = sender.tag
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
    
    @IBAction func onClickDescription(_ sender: Any) {
        descriptionTextView.becomeFirstResponder()
    }
    @IBAction func onClickServiceFiled(_ sender: Any) {
        
        popupView.isHidden = false
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        
        popupView.isHidden = true
    }
    
    @IBAction func onClickSelect(_ sender: Any) {
        serviceId = ""
        selectedServiceNames = ""
        service1Field.placeholder = ""
        
        for item in serviceTypeData {
        
            if item.selected {
                serviceId += item.index + ","
                selectedServiceNames += item.serviceTypeName + ", "
            }
        }
        
        serviceId = String(serviceId.dropLast())
        selectedServiceNames = String(selectedServiceNames.dropLast())
        selectedServiceNames = String(selectedServiceNames.dropLast())
        lblSelectedServices.text = selectedServiceNames
        serviceView.layoutIfNeeded()
        popupView.isHidden = true
        
    }
    
    @IBAction func onClickRegister(_ sender: Any) {
        
        let mainImage = mainImageView.image
        let logoImage = logoImageView.image
        let certificationImage = certificationImageView.image
       
        var isTravelService = 0
        
        if travelServiceSwitchBtn.isOn {
            isTravelService = 1
        } else {
            isTravelService = 0
        }
        let description = descriptionTextView.text!
        
        if mainImage == nil {
            showToast(R.string.PUT_MAINIMAGE)
            return
        }
        if logoImage == nil {
            showToast(R.string.PUT_LOGOIMAGE)
            return
        }
        if certificationImage == nil {
            showToast(R.string.TAKE_CERTIFICATION)
            return
        }
        
        if tfBusinessName.text!.isEmpty {
            showToast(R.string.PUT_BUSINESSNAME)
        }
        
        if tfFacebook.text!.isEmpty {
            showToast(R.string.PUT_FACEBOOKLINK)
            return
        }
        
        if tfInstagram.text!.isEmpty {
            showToast(R.string.PUT_INSTAGRAMLINK)
            return
        }
        
        if (lblSelectedServices.text!.isEmpty)  {
            showToast(R.string.SELECT_SERVICE)
            return
        }
        if description.isEmpty {
            showToast(R.string.INPUT_DESCRIPTION)
        }
        
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        ProviderApiManager.registerService(userId: Defaults[\.userId]!, service_id: serviceId, description: description, isTravelService: isTravelService, address: Defaults[\.userLocation]!, latitude: Defaults[\.myLat]!, longitude: Defaults[\.myLng]!, certifications: [certificationImage!], mainImage: mainImage!, logoImage: logoImage!, fb_link: tfFacebook.text!, insta_link: tfInstagram.text!, business_name: tfBusinessName.text!, completion: {(isSuccess, data) in
            
            if (isSuccess){
                self.gotoProviderVC("ProviderHomeVC")
                self.hud.hide(animated: true)
                
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

//MARK:-- TableViewExtension
extension CompleteProviderProfileVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

            if serviceTypeData[indexPath.row].selected {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        serviceTypeData[indexPath.row].selected = !serviceTypeData[indexPath.row].selected
        serviceList.reloadData()
    }
}

//MARK: TableViewDataSource
extension CompleteProviderProfileVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceTypeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectServiceCell", for: indexPath) as! SelectServiceCell
        cell.entity = serviceTypeData[indexPath.row]
        return cell
    }
}


//MARK:-  ImagePickerDelegate
extension CompleteProviderProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[.editedImage] as? UIImage {
            
            
            if selectedIndex == 0 {
                self.mainImageView.image = img
                //self.addImageButton.isHidden = true
                self.addImageLabel.isHidden = true
            }else if selectedIndex == 1 {
                self.logoImageView.image = img
                //self.addLogoButton.isHidden = true
                self.addLogoLabel.isHidden = true
            }else {
                self.certificationImageView.image = img
                //self.certificationButton.isHidden = true
                self.certificationLabel.isHidden = true
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}
