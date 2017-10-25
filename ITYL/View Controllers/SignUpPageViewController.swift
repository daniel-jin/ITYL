
//
//  SignUpPageViewController.swift
//  ITYL
//
//  Created by Daniel Jin on 10/25/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import UIKit

enum ButtonState {
    case selected
    case notSelected
}

class SignUpPageViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var bodyView: UIView!
    
    var buttonState: ButtonState = .notSelected
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
    }
    
    
    //MARK: - Appearance
    func setAppearance() {
        
        self.view.backgroundColor = UIColor.backgroundAPpGrey
        self.bodyView.backgroundColor = .white
        
        // set background image
        coverPhotoImageView.image = UIImage(named: "whiteBackground")
        coverPhotoImageView.contentMode = .scaleAspectFill
        coverPhotoImageView.layer.masksToBounds = true
        backgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        
        // profile imageView customization
        profileImageView.image = UIImage(named: "userOne")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.layer.frame.height / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 4
        profileImageView.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).cgColor
        
        // button customization
        submitButton.layer.cornerRadius = 8
        submitButton.layer.masksToBounds = true
        submitButton.layer.borderColor = UIColor.primaryAppBlue.cgColor
        submitButton.layer.borderWidth = 2
        submitButton.setTitleColor(UIColor.primaryAppBlue, for: .normal)
        submitButton.setTitle("Submit", for: .normal)
        
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        switch buttonState {
        case .notSelected:
            
            buttonState = .selected
            
            // button customization
            submitButton.layer.cornerRadius = 8
            submitButton.layer.masksToBounds = true
            submitButton.layer.borderColor = UIColor.primaryAppBlue.cgColor
            submitButton.layer.backgroundColor = UIColor.primaryAppBlue.cgColor
            submitButton.layer.borderWidth = 2
            submitButton.setTitleColor(UIColor.white, for: .normal)
            submitButton.setTitle("submit", for: .normal)
            
        case .selected:
            
            buttonState = .notSelected
            
            // button customization
            submitButton.layer.cornerRadius = 8
            submitButton.layer.masksToBounds = true
            submitButton.layer.borderColor = UIColor.primaryAppBlue.cgColor
            submitButton.layer.backgroundColor = nil
            submitButton.layer.borderWidth = 2
            submitButton.setTitleColor(UIColor.primaryAppBlue, for: .normal)
            submitButton.setTitle("submit", for: .normal)
        }
        
        // Register entered username
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        
        UserController.shared.createUserWith(username: username, photoData: nil) { (success) in
            
            if !success {
                DispatchQueue.main.async {
                    self.presentSimpleAlert(title: "Unable to create an account", message: "Make sure you have network connection, and try again.")
                }
            }
            self.performSegue(withIdentifier: Keys.toChatGroupListsTVCSegue, sender: self)
        }
    }
    
    //MARK: - Alert Controller
    func presentSimpleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
        
    }
}