//
//  NotificationVC.swift
//  beauty
//
//  Created by cs on 2020/3/9.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit

class NotificationVC: BaseViewController {

    @IBOutlet weak var notificationList: UITableView!
    
    var notificationSource = [NotificationModel]()
    var notificationContentSource = ["New message from Angel", "New message from Angel", "New message from Angel", "New message from Angel", "New message from Angel", "New message from Angel", "New message from Angel", "New message from Angel", "New message from Angel", "New message from Angel", "New message from Angel" ]
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar()
        notificationSource.removeAll()
        loadNotificationList()
    }
    
    func setNavBar() {
        
        self.title = "Notification"
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtton.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtton
    }
    
    func loadNotificationList() {
        
        for i in 0 ..< notificationContentSource.count {
            let one = NotificationModel(notificationTitle: "Welcome to Look Salon", notificationContent: notificationContentSource[i])
            notificationSource.append(one)
        }
        notificationList.reloadData()
    }
}

extension NotificationVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gotoNavVC("MessageListVC")
    }
}

//MARK: TableViewDataSource
extension NotificationVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.entity = notificationSource[indexPath.row]
        return cell
    }
}
