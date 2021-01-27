//
//  ChatVC.swift
//  beauty
//
//  Created by cs on 2020/3/10.
//  Copyright © 2020 cs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftyJSON
import SwiftyUserDefaults
import IQKeyboardManagerSwift

class ChatVC: BaseViewController, KeyboardHandler {
    
    @IBOutlet weak var barBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    var messages = [MessageModel]()
//    var target_user = UserModel()
    var sender_id = 0
    var sender_name = ""
    var receiver_id = 0
    var receiver_name = ""
    var room_id = ""
    var type = ""
    
    var customerId = 0
    var customerName = ""
    var providerId = 0
    var providerName = ""
    
    var bottomInset: CGFloat {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets.bottom + 50
        } else {
            // Fallback on earlier versions
            return 50
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardObservers() {[weak self] state in
            guard state else { return }
            self?.messageTableView.scroll(to: .bottom, animated: true)
        }
        sender_name = Defaults[\.userName]!
        sender_id = Defaults[\.userId]!
        configurateChat()
        setNavBar()
        fetchMessages()
    }
    
    func configurateChat() {
        
        if userType == "client" {
            customerId = Defaults[\.userId]!
            customerName = Defaults[\.userName]!
            sender_id = customerId
            sender_name = customerName
            receiver_id = providerId
            receiver_name = providerName
        } else {
            providerId = Defaults[\.userId]!
            providerName = Defaults[\.userName]!
            sender_id = providerId
            sender_name = providerName
            receiver_id = customerId
            receiver_name = customerName
        }
    }
    
    func setNavBar() {
        self.title = receiver_name
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtton.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtton
    }
    @IBAction func onClickSend(_ sender: Any) {
        guard let text = messageField.text, !text.isEmpty else { return }
               let message = MessageModel()
               message.message = text
               //message.sender_id = "\(currentUser!.user_id)"
               //inputTextField.text = nil
               //showActionButtons(false)
               send(message)
    }
    
    func onCallReadMessageApi() {
        CommonApiManager.readMessage(client_id: customerId, provider_id: providerId, chatroom_id: room_id, reader_type: userType, completion: {(isSuccess,data) in

            if isSuccess{} else {
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
    
    func onCallWriteMessageApi(content: String) {
        
        CommonApiManager.writeMessage(client_id: customerId, provider_id: providerId, chatroom_id: room_id, sender_type: userType, content: content, completion: {(isSuccess,data) in

            if isSuccess{} else {
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

//MARK: Private methods
extension ChatVC {
    
    private func fetchMessages() {
        
        room_id = "customer_\(customerId)_provider_\(providerId)"
        print("roomid===", room_id)
        messages.removeAll()
        
        let database = Database.database().reference()
        database.child("message")
        .child(room_id)
        .observe(.childAdded) { (snapshot) in
            print("snapshot===", snapshot.value ?? "" as Any)
            if let messageData = snapshot.value as? [String:AnyObject] {
                let objFirst =  MessageModel.parseMessageData(ary: NSArray(object:messageData)).object(at: 0)
                self.messages.append(objFirst as! MessageModel)
            }
            self.messages = self.messages.sorted(by: {$0.time < $1.time})
           
            self.messageTableView.reloadData()
            self.messageTableView.scroll(to: .bottom, animated: true)
        }
        if messages.count == 0 {
            //self.hideLoadingView()
        }
        
        onCallReadMessageApi()
    }
    
    private func send(_ message: MessageModel) {
              
        if messageField.text!.trimmed == "" {
            self.showAlertDialog(title: CONSTANT.APP_NAME, message: "Type message", positive: CONSTANT.OK, negative: nil)
        } else {
        
            var messageData = [String: Any]()
           
            messageData = ["message" : message.message,
                           "receiver_id" : receiver_id,
                           "receiver_img": "",
                           "receiver_name": "\(receiver_name)",
                           "sender_id" : "\(sender_id)" ,
                           "sender_img" : "",
                           "sender_name" : "\(sender_name)",
                           "time" : Date().toMillis()!]
           
            let key = Database.database().reference().child("message").child(room_id).childByAutoId().key!
            Database.database().reference().child("message").child(room_id).child(key).setValue(messageData)
            messageField.text = ""
        }
        
        onCallWriteMessageApi(content: message.message)
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        var senderid = 0
        senderid = sender_id
        let cell = tableView.dequeueReusableCell(withIdentifier: message.sender_id == "\(senderid)" ? "MessageTableViewCell" : "UserMessageTableViewCell") as! MessageTableViewCell
        cell.set(message)
        return cell
        
    }
  
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard tableView.isDragging else { return }
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3, animations: {
            cell.transform = CGAffineTransform.identity
        })
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        switch message.contentType {
    //    case .location:
    //      let vc: MapPreviewController = UIStoryboard.controller(storyboard: .previews)
    //      vc.locationString = message.message
    //      navigationController?.present(vc, animated: true)
    //    case .photo:
    //      let vc: ImagePreviewController = UIStoryboard.controller(storyboard: .previews)
    //      vc.imageURLString = message.message
    //      navigationController?.present(vc, animated: true)
        default: break
        }
    }
}

extension ChatVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //showActionButtons(false)
        return true
    }
}

extension ChatVC: MessageTableViewCellDelegate {
  
    func messageTableViewCellUpdate() {
        messageTableView.beginUpdates()
        messageTableView.endUpdates()
    }
}
extension Date {
    
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    init(millis: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(millis / 1000))
        self.addTimeInterval(TimeInterval(Double(millis % 1000) / 1000 ))
    }
    
}

