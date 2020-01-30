//
//  MessageInputViewController.swift
//  Assignment
//
//  Created by Asad Choudhary on 1/27/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import UIKit

enum MessageInputType { // Type to identify flow, either Signing or Verification
    case sign
    case verify
}

// Same class is used for taking message input while signing & Verification
class MessageInputViewController: UIViewController {

    @IBOutlet weak var btSubmit: UIButton!
    @IBOutlet weak var tfMessage: UITextField!
    
    var viewModel : MessageInputViewModel?
    var type: MessageInputType?
    let showSignatureSigue = "showSignatureAction"
    let showVerificationSigue = "showVerificationAction"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializations()
    }
    
    func initializations() {
        self.navigationItem.title = type == .sign ? "Signing" : "Verification"
        btSubmit.setTitle(type == .sign ? "Sign Message" : "Verify Message", for: .normal)
        tfMessage.delegate = self
    }

    // Click Event
    @IBAction func ClickSubmit(_ sender: UIButton) {
        performSubmition()
    }
    
    func performSubmition() {
        if type == .sign {
            self.viewModel?.signMessage(message: tfMessage.text)
        } else if type == .verify {
            self.viewModel?.checkForVerificationValidity(message: tfMessage.text)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == showSignatureSigue) {
             if let vc = segue.destination as? SignatureViewController {
                vc.viewModel = self.viewModel?.signatureViewModel() // Initialization of Signature View Model
            }
        } else if (segue.identifier == showVerificationSigue) {
             if let vc = segue.destination as? VerificationViewController {
                vc.viewModel = self.viewModel?.verificationViewModel() // Initialization of Verification View Model
                vc.viewModel?.delegate = vc
            }
        }
    }
    
   
}

extension MessageInputViewController: MessageInputViewModelDelegate {
    // Delegate Methods
    func onEmptyInput() {
        tfMessage.shake()
    }
    func onSuccess() {
        // if type is sign, signature generated successfully, move to next viewcontroller to show QR Code & if type is verify move to next QRCode Scanner Controller
        performSegue(withIdentifier: type == .sign ? showSignatureSigue : showVerificationSigue, sender: self)
    }
    
    func onError(error: ErrorResult?) {
        Utils.showSimpleAlert(controller: self, title: "An error occured", message: error?.localizedDescription, buttonText: "Cancel")
    }
}

extension MessageInputViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSubmition()
        return true
    }
}


