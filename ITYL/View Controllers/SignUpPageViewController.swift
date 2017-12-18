
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

class SignUpPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    let imagePicker = UIImagePickerController()
    var buttonState: ButtonState = .notSelected

    //MARK: - IBOutlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var bodyView: UIView!
    
    // MARK: - IBActions
    @IBAction func chooseProfilePhotoButtonTapped(_ sender: UIButton) {
        
        // Load ImagePicker
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.modalPresentationStyle = .popover
        present(imagePicker, animated: true, completion: nil)
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
        
        guard let profileImage = profileImageView.image else { return }
        
        UserController.shared.createUserWith(username: username, photoData: UIImageJPEGRepresentation(profileImage, 1.0)) { (success) in
            
            if success {
                NSLog("Successfully created user")
                self.performSegue(withIdentifier: Keys.toChatGroupListSegue, sender: self)
            }
            if !success {
                DispatchQueue.main.async {
                    Helpers.presentSimpleAlert(title: "Unable to create an account", message: "Make sure you have network connection, and try again.", viewController: self)
                }
            }
            return
        }
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
        profileImageView.image = #imageLiteral(resourceName: "defaultPhoto")
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
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        setAppearance()
    }
    
    //MARK: - Delegates
    @objc func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
