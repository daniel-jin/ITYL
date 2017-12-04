//
//  LaunchScreenViewController.swift
//  ITYL
//
//  Created by Daniel Jin on 10/25/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    let cloudKitManager = CloudKitManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(segueToChatGroupListTVC), name: Keys.CurrentUserWasSetNotification, object: nil)
        
        cloudKitManager.checkCloudKitAvailability { (success) in
            // iCloud account not logged in
            if !success {
                
                let alertController = UIAlertController (title: "iCloud Login Needed", message: "Please log into your iCloud account in Settings to use this application.", preferredStyle: .alert)
                
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                alertController.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                // iCloud account is logged in - now check if we already ahve a user
                UserController.shared.fetchCurrentUser { (success) in
                    if success {
                        self.segueToChatGroupListTVC()
                    } else { self.segueToSignUpVC() }
                }
            }
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
