//
//  Utils.swift
//  Assignment
//
//  Created by Asad Choudhary on 1/27/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import UIKit

class Utils {
    // A utility method to show Alert from different ViewControllers
    static func showSimpleAlert(controller: UIViewController, title: String = "", message: String? = "", buttonText: String = "OK", handler: ((UIAlertAction) -> Void)? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: buttonText, style: .default, handler: handler))
        controller.present(ac, animated: true)
    }
}
