//
//  Extensions.swift
//  Assignment
//
//  Created by Asad Choudhary on 1/27/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import Foundation
import UIKit

extension Data
{
    func toString() -> String?
    {
        return String(data: self, encoding: .utf8)
    }
}

extension UIView {
    // Shake View, used to validate TextFields in case of failed validations
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
