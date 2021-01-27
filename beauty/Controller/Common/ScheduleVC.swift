//
//  ScheduleVC.swift
//  beauty
//
//  Created by cs on 2020/3/22.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import iOSDropDown
import SwiftyJSON
import SwiftyUserDefaults
import MBProgressHUD

class ScheduleVC: BaseViewController {

    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var serviceDateField: UITextField!
    @IBOutlet weak var serviceLocationField: UITextField!
    @IBOutlet weak var isTravelServiceBtn: UIButton!
    @IBOutlet weak var serviceTypeField: DropDown!
    @IBOutlet weak var commentTextView: UITextView!
        
    var hud : MBProgressHUD!
    var providerId = 0
    var serviceId = 0
    var providerName = ""
    var travelServiceStatus = "YES"
    var scheduleTimeStamp : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if userType == "client" {
            fullNameField.text = providerName
            fullNameField.placeholder = "Business Name"
        } else {
            fullNameField.placeholder = "Customer Name"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setServiceTypeDropDown()
        serviceLocationField.text = serviceLocation
        setNavbar()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setNavbar() {
        self.title = "Appointment"
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtton.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtton
    }
    
    func setServiceTypeDropDown() {
        
        serviceTypeField.optionArray = ["HAIR CUT","HAIR COLOR","STYLING & FINISHING","HAIR TEXTURE","HAIR TREATMENTS","HAIR MEN'S SERVICES","MANICURE","PEDICURE","ARTIFICIAL NAILS","HAIR REMOVAL","LASH EXTENSIONS","MAKEUP","SKIN & BODY"]
        serviceTypeField.optionIds = [10,11,12,13,14,15,20,21,22,23,24,25,26]
        serviceTypeField.isSearchEnable = false
        serviceTypeField.selectedRowColor = .clear
        serviceTypeField.rowHeight = 40
        serviceTypeField.checkMarkEnabled = true
        serviceTypeField.arrowColor = .white
        serviceTypeField.didSelect(completion: { (selected, index, id)  in
            self.serviceTypeField.isSearchEnable = true
            self.serviceId = id
        })
    }
    
    @IBAction func onClickDateField(_ sender: UITextField) {
        
        let timePickerView:UIDatePicker = UIDatePicker()
        timePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        sender.inputView = timePickerView
        timePickerView.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func timePickerValueChanged(_ sender:UIDatePicker){
      
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy HH:mm"
        serviceDateField.text = dateFormatter.string(from: sender.date)
        scheduleTimeStamp = (Int((sender.date).timeIntervalSince1970 * 1000))
        print("scheduleTimeStamp==", scheduleTimeStamp)
    }
 
    @IBAction func onClickLocationField(_ sender: Any) {
        
        let mapViewVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileMapVC") as! ProfileMapVC
        mapViewVC.previousVC = "scheduleVC"
        self.navigationController?.pushViewController(mapViewVC, animated: true)
    }
    
    @IBAction func onClickYES(_ sender: Any) {
        
        if isTravelServiceBtn.titleLabel!.text == "YES" {
            travelServiceStatus = "NO"
            isTravelServiceBtn.setTitle(travelServiceStatus, for: .normal)
            
        } else {
            travelServiceStatus = "YES"
            isTravelServiceBtn.setTitle(travelServiceStatus, for: .normal)
        }
    }
    
    @IBAction func onClickSet(_ sender: Any) {
        
        onCheckValidate()
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        
        let bookingAddress = serviceLocationField.text!
        let serviceComment = commentTextView.text!
        let userName = fullNameField.text!
        
        if userType == "client" {
            
            CustomerApiManager.addSchedule(client_id: Defaults[\.userId]!, provider_id: providerId, user_type: userType, service_id: "\(serviceId)", scheduleTime: scheduleTimeStamp, address: bookingAddress, comment: serviceComment, isTravelService: travelServiceStatus.lowercased(), user_name: userName, completion: {(isSuccess, data) in
            
                if (isSuccess){
                    self.gotoNavVC("BookingHistoryVC")
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
        } else {
            
            ProviderApiManager.addSchedule(client_id: 0, provider_id: Defaults[\.userId]!, user_type: userType, service_id: "\(serviceId)", scheduleTime: scheduleTimeStamp, address: bookingAddress, comment: serviceComment, isTravelService: travelServiceStatus.lowercased(), user_name: userName, completion: {(isSuccess, data) in
            
                if (isSuccess){
                    self.hud.hide(animated: true)
                    self.gotoNavVC("BookingHistoryVC")
                    
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
    
    func onCheckValidate() {
        let fullName =  fullNameField.text!
        let date = serviceDateField.text!
        let location = serviceLocationField.text!
        let serviceType = serviceTypeField.text!
        
        if fullName.isEmpty {
            showToast(R.string.INPUT_OPPOSITE_NAME)
            return
        }
        if date.isEmpty {
            showToast(R.string.INPUT_DATE)
            return
        }
        if location.isEmpty {
            showToast(R.string.INPUT_LOCATION)
            return
        }
        if serviceType.isEmpty {
            showToast(R.string.SELECT_SERVICE)
            return
        }
    }
}
