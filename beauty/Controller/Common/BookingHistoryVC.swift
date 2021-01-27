//
//  BookingHistoryVC.swift
//  beauty
//
//  Created by cs on 2020/3/6.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON
import MBProgressHUD

class BookingHistoryVC: BaseViewController {
    
    @IBOutlet weak var uiTableview: UITableView!
    
    var pastBookings = [BookingModel]()
    var liveBookings = [BookingModel]()
    var hud : MBProgressHUD!
    
    var sectionTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiTableview.dataSource = self
        uiTableview.delegate = self
        uiTableview.tableFooterView = UIView()
        
        if userType == "client"{
            loadCustomerBookingData()
        }else {
            loadProviderBookingData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavBar()
    }
    
    func setNavBar() {
        
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtton.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtton
        
        self.title = "Appointments"
    }
    
    
    //MARK:- custom action
   
    @IBAction func onClickMenu(_ sender: Any) {
        panel?.openLeft(animated: true)
    }
    
    //MARK:- load booking history -- call server
    
    func loadCustomerBookingData() {
        
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        
        CustomerApiManager.getSchedule(user_id: Defaults[\.userId]!, completion: {(isSuccess,data) in

            if isSuccess{
                let dict = JSON(data as Any)
                let previousSchedules = dict[CONSTANT.PREVIOUS_SCHEDULE].arrayValue
                for one in previousSchedules {
                    let previousSchedule = BookingModel(dict: one)
                    self.pastBookings.append(previousSchedule)
                }
                let incomingSchedules = dict[CONSTANT.INCOMING_SCHEDULE].arrayValue
                for schedule in incomingSchedules {
                    let incomingSchedule = BookingModel(dict: schedule)
                    self.liveBookings.append(incomingSchedule)
                }
                self.hud.hide(animated: true)
                
                if self.pastBookings.count != 0 {
                    self.sectionTitles.append("Previous Appointment")
                }
                
                if self.liveBookings.count != 0 {
                    self.sectionTitles.append("Incoming Appointment")
                }
                
                if self.pastBookings.count > 0 && self.liveBookings.count > 0 {
                    self.sectionTitles.sort{ $0 > $1 }
                }
                
                self.uiTableview.reloadData()
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
    
    func loadProviderBookingData() {
        
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        
        ProviderApiManager.getSchedule(user_id: Defaults[\.userId]!, completion: {(isSuccess,data) in

            if isSuccess{
                let dict = JSON(data as Any)
                let previousSchedules = dict[CONSTANT.PREVIOUS_SCHEDULE].arrayValue
                for one in previousSchedules {
                    let previousSchedule = BookingModel(dict: one)
                    self.pastBookings.append(previousSchedule)
                }
                let incomingSchedules = dict[CONSTANT.INCOMING_SCHEDULE].arrayValue
                for schedule in incomingSchedules {
                    let incomingSchedule = BookingModel(dict: schedule)
                    self.liveBookings.append(incomingSchedule)
                }
                self.hud.hide(animated: true)
                
                if self.pastBookings.count != 0 {
                    self.sectionTitles.append("Previous Appointment")
                }
                
                if self.liveBookings.count != 0 {
                    self.sectionTitles.append("Incoming Appointment")
                }
                
                if self.pastBookings.count > 0 && self.liveBookings.count > 0 {
                    self.sectionTitles.sort{ $0 > $1 }
                }
                
                self.uiTableview.reloadData()
                
            } else{
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
    
    
    @IBAction func onClickAdd(_ sender: Any) {
        
        let scheduleVC = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleVC") as! ScheduleVC
             scheduleVC.providerId = -1
        self.navigationController?.pushViewController(scheduleVC, animated: true)
    }
}

extension BookingHistoryVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.pastBookings.count == 0 {
            return liveBookings.count
        } else if liveBookings.count == 0 {
            return pastBookings.count
        } else {
            if section == 0 {
                return pastBookings.count
            } else {
                return liveBookings.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell", for: indexPath) as! BookingCell
        
        if self.pastBookings.count == 0 {
            cell.entity = liveBookings[indexPath.row]
        } else if liveBookings.count == 0 {
            cell.entity = pastBookings[indexPath.row]
        } else {
            if indexPath.section == 0 {
                cell.entity = pastBookings[indexPath.row]
            } else {
                cell.entity = liveBookings[indexPath.row]
            }
        }
        
        return cell
    }
    
}

