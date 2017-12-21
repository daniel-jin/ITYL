//
//  AddChatGroupViewController.swift
//  ITYL
//
//  Created by Daniel Jin on 10/26/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import UIKit
import CloudKit

class AddChatGroupViewController: UIViewController {
    
    // Optional property chatGroup - will be assigned if successfully created by user
    var chatGroup: ChatGroup?
    
    // MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var startChattingButton: UIButton!
    @IBOutlet weak var searchUsernameButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func searchUsernameButtonTapped(_ sender: Any) {
        
        guard let username = usernameTextField.text,
            !username.isEmpty else {
            Helpers.presentSimpleAlert(title: "Oops!", message: "Please enter a chat group name", viewController: self)
            return
        }
        
        // See if there is a match for the searched username
        UserController.shared.searchForUserWith(username: username) { (success, user) in
            
            if !success {
                Helpers.presentSimpleAlert(title: "Oops!", message: "There is no username that matches your search. Try again.", viewController: self)
                return
            } else {
                
                DispatchQueue.main.async {
                    
                    self.searchUsernameButton.isEnabled = false
                    
                    // Create the chat group
                    guard let addToChatGroup = user else {
                        NSLog("Error adding second user to chat")
                        return
                    }
                    
                    ChatGroupController.shared.createChatGroupWith(name: username, addUser: addToChatGroup, subscriptionID: UUID().uuidString, completion: { (success, chatGroup) in
                        if success {
                            
                            guard let chatGroup = chatGroup else { return }
                            
                            DispatchQueue.main.async {
                                self.startChattingButton.isHidden = false
                                self.chatGroup = chatGroup
                            }
                            
                            CloudKitManager().subscribeToCreationOfRecords(ofType: Keys.messageRecordType, chatGroup: chatGroup)
                        }
                    })
                }
            }
        }
    }

    @IBAction func startChattingButtonTapped(_ sender: Any) {

        performSegue(withIdentifier: Keys.toChatGroupMessagesSegue, sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startChattingButton.isHidden = true
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Keys.toChatGroupMessagesSegue {
            
            // Set segue destination as the Messages VC
            guard let chatGroupDetailVC = segue.destination as? ChatMessagesCollectionViewController,
                let chatGroup = chatGroup else {
                return
            }
            
            // Send over the chatGroup to the detail VC
            chatGroupDetailVC.chatGroup = chatGroup
        }
    }

}
