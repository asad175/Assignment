//
//  InputPrivateKeyViewModel.swift
//  Assignment
//
//  Created by Asad Choudhary on 1/26/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//



protocol SetupViewModelDelegate {
    func onSuccess()
    func onError(error: ErrorResult?)
    func onEmptyInput()
}

class SetupViewModel {
    
    var userWallet: Wallet?
    var delegate: SetupViewModelDelegate?
    var web3Helper: Web3Helper?
    
    init(delegate: SetupViewModelDelegate) {
        userWallet = Wallet()
        self.delegate = delegate
        web3Helper = Web3Helper(delegate: self)
    }
    
    func accountViewModel() -> AccountViewModel? {
        // Initialize AccountViewModel and pass wallet object to it
        guard let userWallet = userWallet else {return nil}
        return AccountViewModel.init(userWallet: userWallet)
    }
    
    func getAccountDetails(privateKey: String?) {
        if (privateKey != nil && privateKey!.count > 0) {
            web3Helper?.getAccountDetails(privateKey: privateKey!, completion: { (address, balance) -> Void in
                self.userWallet?.privateKey = privateKey!
                self.userWallet?.address = address
                self.userWallet?.balance = balance
                self.delegate?.onSuccess()
            })
        } else {
            delegate?.onEmptyInput()
        }
    }

}

extension SetupViewModel: Web3HelperDelegate {
    // Handle Error Event Received by Web3Helper Class
    func onError(error: ErrorResult?) {
        delegate?.onError(error: error)
    }
    
    
}
