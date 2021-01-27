//
//  AllReviewVC.swift
//  beauty
//
//  Created by cs on 2020/4/1.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults
import MBProgressHUD

class AllReviewVC: BaseViewController {

    @IBOutlet weak var reviewList: UITableView!
    
    var reviewDataSource = [ReviewModel]()
    var providerId = 0
    var hud : MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.reviewList.tableFooterView = UIView()
        initTableView()
        setNavBar()
    }
    
    func setNavBar() {
        
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtton.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtton
        self.title = "All Review"
    }
    func initTableView() {
        
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        
        CustomerApiManager.getProviderInfo(provider_id: providerId, completion: {(isSuccess,data) in

            if isSuccess{
                let dict = JSON(data as Any)
                let reviews = dict[CONSTANT.REVIEW].arrayValue
                for one in reviews {
                    let review = ReviewModel(dict: one)
                    self.reviewDataSource.append(review)
                }
                
                self.reviewList.reloadData()                
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
}

//MARK:--TableView Extension
extension AllReviewVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK: TableViewDataSource
extension AllReviewVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        cell.entity = reviewDataSource[indexPath.row]
        return cell
    }
}
