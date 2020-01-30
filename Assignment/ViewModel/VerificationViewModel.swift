//
//  SplitViewController.swift
//  Assignment
//
//  Created by Asad Choudhary on 1/28/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

protocol VerificationViewDelegate {
    func onSuccess()
    func onFailure()
    func onError(error: ErrorResult?)
}

class VerificationViewModel {

    var userWallet: Wallet?
    var message: String?
    var delegate: VerificationViewDelegate?
    var web3Helper: Web3Helper?
    
    init(userWallet: Wallet, message: String) {
        self.userWallet = userWallet
        self.message = message
        web3Helper = Web3Helper(delegate: self)
    }
    
    func verifySignature(signature: String) {
        guard let privateKey = userWallet?.privateKey, let message = self.message else {
            delegate?.onError(error: ErrorResult.custom(errorDescription: "Unable to find Private Key or Message"))
            return
        }
        // Perform Verification
        web3Helper?.verifySignature(privateKey: privateKey, message: message, signature: signature, completion: { (isSuccess) in
            // Handle Verification Response
            if (isSuccess) {
                self.delegate?.onSuccess()
            } else {
                self.delegate?.onFailure()
            }
        })
    }
    
}

extension VerificationViewModel: Web3HelperDelegate {
    // Handle Error Event Received by Web3Helper Class
    func onError(error: ErrorResult?) {
        delegate?.onError(error: error)
    }
}
