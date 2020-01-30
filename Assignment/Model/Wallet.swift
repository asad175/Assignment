//
//  Wallet.swift
//  Assignment
//
//  Created by Asad Choudhary on 1/26/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import UIKit

// Data Model to save user's privateKey, address & balance and pass to different ViewControllers when required
class Wallet {
    
    var privateKey: String
    var address: String
    var balance: Double
    
    init() {
        privateKey = ""
        address = ""
        balance = 0.0
    }
    
    init(privateKey: String, address: String, balance: Double) {
        self.privateKey = privateKey
        self.address = address
        self.balance = balance
    }
}
