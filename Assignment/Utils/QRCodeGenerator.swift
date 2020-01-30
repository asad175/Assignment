//
//  SplitViewController.swift
//  Assignment
//
//  Created by Asad Choudhary on 1/28/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import UIKit

// A utility class to generate QR Code From string
class QRCodeGenerator {

    static func generateQRCode(from str: String?) -> UIImage? {

        guard  let code = str, let data = code.data(using: .utf8) else {return nil}
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 6, y: 6)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
}
