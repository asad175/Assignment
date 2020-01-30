//
//  AccountViewModel.swift
//  Assignment
//
//  Created by Asad Choudhary on 1/26/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//


protocol AccountViewModelDelegate {
    func updateAccountDetails(address: String, balance: String)
}

class AccountViewModel {

    var userWallet: Wallet?
    var delegate: AccountViewModelDelegate?
    
    init(userWallet: Wallet) {
        self.userWallet = userWallet
    }
    
    func initializations() {
        guard let wallet = userWallet else { return }
        delegate?.updateAccountDetails(address: wallet.address, balance: String(wallet.balance) + " Ether") // Update UI through Delegate method
    }
    
    func messageInputViewModel() -> MessageInputViewModel? {
        // Initialize MessageInputViewModel and pass wallet object to it
        guard let userWallet = userWallet else {return nil}
        return MessageInputViewModel.init(userWallet: userWallet)
    }
    
}
