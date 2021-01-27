//
//  SearchproviderVC.swift
//  beauty
//
//  Created by cs on 2020/3/4.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import Cosmos
import SwiftyJSON
import SwiftyUserDefaults
import MBProgressHUD

class SearchproviderVC: BaseViewController {

    @IBOutlet weak var providerList: UITableView!
    var hud : MBProgressHUD!
    var serviceNames = [
        10 : "HAIR CUT",
        11 : "HAIR COLOR",
        12 : "STYLING & FINISHING",
        13 : "HAIR TEXTURE",
        14 : "HAIR TREATMENTS",
        15 : "MENS SERVICES",
        
        20 : "MANICURE",
        21 : "PEDICURE",
        22 : "ARTIFICIAL NAILS",
        23 : "HAIR REMOVAL",
        24 : "LASH EXTENSIONS",
        25 : "MAKEUP",
        26 : "SKIN & BODY"
    ]
    
    var dataSource = [ProviderModel]()
    var service_id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service_id = key
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtton.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtton
        self.title = serviceNames[key]
        
        
        loadProviderList()
    }
    
    func loadProviderList() {
        
        dataSource.removeAll()
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        CustomerApiManager.findProviderByLocation(service_id: service_id, latitude: Defaults[\.myLat]!, longitude: Defaults[\.myLng]!, completion: {(isSuccess,data) in

            if isSuccess{
                let dict = JSON(data as Any)
                let providers = dict[CONSTANT.USER_DATA].arrayValue
                for one in providers {
                    let provider = ProviderModel(dict:one)
                    self.dataSource.append(provider)
                }
                self.providerList.reloadData()
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
    
    @IBAction func onClickFilter(_ sender: Any) {
        
        let alert = UIAlertController(title: "Search Provider", message: "", preferredStyle: .alert)

        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .alert
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Please input provider business name."
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            let providerName = alert.textFields![0].text!
            self.filter(providerName: providerName)}))
        alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: nil))

        DispatchQueue.main.async(execute:  {
         self.present(alert, animated: true, completion: nil)
        })
    }
    
    func filter(providerName: String) {
        
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        dataSource.removeAll()
        CustomerApiManager.findProviderByName(service_id: service_id, providerName: providerName, completion: {(isSuccess,data) in

            if isSuccess{
                let dict = JSON(data as Any)
                let providers = dict[CONSTANT.USER_DATA].arrayValue
                for one in providers {
                    let provider = ProviderModel(dict:one)
                    self.dataSource.append(provider)
                }
                self.providerList.reloadData()
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
                        self.showToast("\(message).", duration: 2, position: .bottom)
                    }
                    else {
                        self.showToast("Error", duration: 2, position: .bottom)
                    }
                }
                self.hud.hide(animated: true)
            }
        })
    }
    
    @IBAction func onClickChangeLocation(_ sender: Any) {
         gotoNavVC("MapVC")
    }
    
    func change() {
        showToast("Your location was changed successfully.")
    }
    
    @IBAction func onClickView(_ sender: UIButton) {
        
        let providerInformationVC = self.storyboard?.instantiateViewController(withIdentifier: "ProviderInformationVC") as! ProviderInformationVC
        providerInformationVC.providerId = dataSource[sender.tag].provider_id
        self.navigationController?.pushViewController(providerInformationVC, animated: true)
    }
}
//MARK:--TableView Extension
extension SearchproviderVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK: TableViewDataSource
extension SearchproviderVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProviderListCell", for: indexPath) as! ProviderListCell
        cell.entity = dataSource[indexPath.row]
        cell.viewButton.tag = indexPath.row
        return cell
    }
}
