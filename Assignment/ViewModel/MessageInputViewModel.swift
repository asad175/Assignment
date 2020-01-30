//
//  MessageInputViewModel.swift
//  Assignment
//
//  Created by Asad Choudhary on 1/28/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

protocol MessageInputViewModelDelegate {
    func onSuccess()
    func onError(error: ErrorResult?)
    func onEmptyInput()
}

class MessageInputViewModel {

    var userWallet: Wallet?
    var delegate: MessageInputViewModelDelegate?
    var web3Helper: Web3Helper?
    var signature: String?
    var message: String?
    
    init(userWallet: Wallet) {
        self.userWallet = userWallet
        web3Helper = Web3Helper(delegate: self)
    }
   
    func validateMessage(message: String?) -> Bool { // Check for valid input
        if (message == nil || message!.count == 0) {
            delegate?.onEmptyInput()
            return false
        }
        return true
    }
    
    func checkForVerificationValidity(message: String?) {
        if (validateMessage(message: message)) {
            self.message = message!
            self.delegate?.onSuccess()
        }
    }
    
    func signMessage(message: String?) {
        if (validateMessage(message: message)) {
            // perform signing
            guard let privateKey = userWallet?.privateKey else {
                delegate?.onError(error: ErrorResult.custom(errorDescription: "Unable to find Private Key"))
                return
            }
            web3Helper?.signMessaage(privateKey: privateKey, message: message!, completion: { (signature) -> Void in
                // Success in signing
                self.signature = signature
                self.message = message!
                self.delegate?.onSuccess()
            })
        }
    }
    
    func signatureViewModel() -> SignatureViewModel? {
        // Initialize SignatureViewModel and pass message & signature object to it
        guard let signature = signature, let message = message else {return nil}
        return SignatureViewModel.init(message: message, signature: signature)
    }
    
    func verificationViewModel() -> VerificationViewModel? {
        // Initialize VerificationViewModel and pass wallet & Message object to it
        guard let message = message, let userWallet = self.userWallet else {return nil}
        return VerificationViewModel.init(userWallet: userWallet, message: message)
    }
    
}

extension MessageInputViewModel: Web3HelperDelegate {
    // Handle Error Event Received by Web3Helper Class
    func onError(error: ErrorResult?) {
        delegate?.onError(error: error)
    }
}

