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
    
    // MARK: - IBOutlets
    @IBOutlet weak var chatGroupNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var startChattingButton: UIButton!
    
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
                    // Check for chat group name value
                    guard let chatGroupName = self.chatGroupNameTextField.text,
                        !chatGroupName.isEmpty else {
                            Helpers.presentSimpleAlert(title: "Oops!", message: "Please enter a chat group name", viewController: self)
                            return }
                    
                    // Create the chat group
                    
                    guard let addToChatGroup = user else {
                        NSLog("Error adding second user to chat")
                        return
                    }
                    
                    ChatGroupController.shared.createChatGroupWith(name: chatGroupName, addUser: addToChatGroup, completion: { (success) in
                        if success {
                            DispatchQueue.main.async {
                                self.startChattingButton.isHidden = false
                            }
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func startChattingButtonTapped(_ sender: Any) {
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startChattingButton.isHidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
