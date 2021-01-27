//
//  MessageListVC.swift
//  beauty
//
//  Created by cs on 2020/3/9.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import FAPanels
import SwiftyUserDefaults
import SwiftyJSON
import MBProgressHUD

class MessageListVC: BaseViewController {

    var providerMenuVC : ProviderMenuVC!
    var hud : MBProgressHUD!
    
    @IBOutlet weak var messageList: UITableView!
    
    var messageDataSource = [MessageListModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        messageDataSource.removeAll()
        loadMessageList()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

//        viewConfigurations()
        setNavBar()
        
    }
    
    func setNavBar() {
        
        self.title = "ALL MESSAGES"
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtton.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtton
    }
    
    func loadMessageList() {
        
        self.hud = self.progressHUD(view: self.view, mode: .indeterminate)
        self.hud.show(animated: true)
        
        CommonApiManager.getChatList(user_id: Defaults[\.userId]!, userType: "\(userType)", completion:  {(isSuccess,data) in

            if isSuccess{
                let dict = JSON(data as Any)
                let chatLists = dict["lists"].arrayValue
                
                for one in chatLists {
                    let chat = MessageListModel(dict: one)
                    self.messageDataSource.append(chat)
                }
                self.messageList.reloadData()
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
    
    @IBAction func onClickMenu(_ sender: Any) {
        panel?.openLeft(animated: true)
    }
    
}

extension MessageListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if userType == "client" {
            
            let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            chatVC.providerId = messageDataSource[indexPath.row].senderId
            chatVC.providerName = messageDataSource[indexPath.row].senderName
            self.navigationController?.pushViewController(chatVC, animated: true)
        } else {
            
            let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            chatVC.customerId = messageDataSource[indexPath.row].senderId
            chatVC.customerName = messageDataSource[indexPath.row].senderName
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}

//MARK: TableViewDataSource
extension MessageListVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageListCell", for: indexPath) as! MessageListCell
        cell.entity = messageDataSource[indexPath.row]
        return cell
    }
}
