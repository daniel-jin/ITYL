//
//  LaunchScreenViewController.swift
//  ITYL
//
//  Created by Daniel Jin on 10/25/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(segueToChatGroupListTVC), name: Keys.CurrentUserWasSetNotification, object: nil)
        
        UserController.shared.fetchCurrentUser { (success) in
            if success {
                self.segueToChatGroupListTVC()
            } else { self.segueToSignUpVC() }
        }
    }

    //MARK: - Navigation
    @objc func segueToChatGroupListTVC() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Keys.toChatGroupListsTVCSegue, sender: self)
        }
        
    }
    
    @objc func segueToSignUpVC() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Keys.toSignUpVCSegue, sender: self)
        }
        
    }

}
