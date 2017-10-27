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
    
    // MARK: - IBActions
    @IBAction func searchUsernameButtonTapped(_ sender: Any) {
        
        guard let username = usernameTextField.text,
            !username.isEmpty else {
            Helpers.presentSimpleAlert(title: "Oops!", message: "Please enter a chat group name", viewController: self)
            return
        }
        
        
        
    }
    
    guard let chatGroupName = chatGroupNameTextField.text,
    !chatGroupName.isEmpty else {
    Helpers.presentSimpleAlert(title: "Oops!", message: "Please enter a chat group name", viewController: self)
    return }
    
    ChatGroupController.shared.createChatGroupWith(name: chatGroupName) { (success) in
    if success {
    self.performSegue(withIdentifier: Keys.toInviteVCSegue, sender: self)
    } else {
    
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
