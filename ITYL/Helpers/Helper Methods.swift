//
//  Helper Methods.swift
//  ITYL
//
//  Created by Daniel Jin on 10/26/17.
//  Copyright © 2017 Daniel Jin. All rights reserved.
//

import Foundation
import UIKit

struct Helpers {
    
    //MARK: - Alert Controller
    static func presentSimpleAlert(title: String, message: String, viewController: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
}
