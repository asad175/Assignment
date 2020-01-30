//
//  SplitViewController.swift
//  Assignment
//
//  Created by Asad Choudhary on 1/28/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import UIKit

class SignatureViewController: UIViewController {

    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var ivqrCode: UIImageView!
    var viewModel : SignatureViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializations()
    }
    
    func initializations() {
        self.navigationItem.title = "Signature"
        guard let viewModel = viewModel, let message = viewModel.message else {return}
        ivqrCode.image = QRCodeGenerator.generateQRCode(from: viewModel.signature)
        labelMessage.text = "Message: \"\(message)\""
    }
}

