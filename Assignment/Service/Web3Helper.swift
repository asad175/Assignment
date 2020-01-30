//
//  Web3Helper.swift
//  Assignment
//
//  Created by Asad Choudhary on 1/27/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import UIKit
import web3swift // using matter-lab web3swift https://github.com/matter-labs/web3swift

protocol Web3HelperDelegate {
    func onError(error: ErrorResult?)
}

class Web3Helper {

    var delegate: Web3HelperDelegate?
    var web3: web3!
    
    init(delegate: Web3HelperDelegate) {
        self.delegate = delegate; // Initialization of Delegate Object to send error to caller ViewControllers
        web3 = Web3.InfuraRinkebyWeb3(accessToken: ServiceConstants.InfuraApiKey) // Rinkeby Infura Endpoint Provider
    }
    
    func getKeystore(privateKey: String) -> EthereumKeystoreV3? {
        let formattedKey = privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
        if let dataKey = Data.fromHex(formattedKey) {
            do {
                let keystore = try EthereumKeystoreV3(privateKey: dataKey)
                return keystore
            } catch {}
        }
        return nil
    }
    
    func getKeystoreManager(privateKey: String) -> KeystoreManager?  {
        guard let keystore = self.getKeystore(privateKey: privateKey) else {return nil}
        let keystoreManager = KeystoreManager([keystore])
        self.web3.addKeystoreManager(keystoreManager)
        return keystoreManager;
    }
    
    func getAddress(privateKey: String) -> EthereumAddress? {
        guard let keystoreManager = self.getKeystoreManager(privateKey: privateKey),
              let address = keystoreManager.addresses?.first else {return nil}
        return address;
    }
    // Function to get Address & Balance by private key
    func getAccountDetails(privateKey: String, completion: @escaping (String, Double) -> ()) {
        
        DispatchQueue.global(qos: .background).async { // perform operation in background thread, because The SDK uses network calls inside.
              do {
                if let walletAddress = self.getAddress(privateKey: privateKey) {
                    let balanceResult = try self.web3.eth.getBalance(address: walletAddress)
                    if let balanceString = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 4, decimalSeparator: "."), let balance = Double(balanceString) {
                        DispatchQueue.main.async {
                            completion(walletAddress.address, balance)
                        }
                        return;
                        }
                    }
                } catch {}
            
            self.sendError(errorString: "Unable to find account details. Please make sure you have entered a correct private key.")
        }
    }
    
    //Method to Sign String message with private key using web3swift lib
    func signMessaage(privateKey: String, message: String, completion: @escaping (String) -> ()) {
        
        DispatchQueue.global(qos: .background).async {

            if let walletAddress = self.getAddress(privateKey: privateKey) {
                let data = message.data(using: .utf8)
                    do {
                        let signMsg = try self.web3.wallet.signPersonalMessage(data!, account: walletAddress);
                        DispatchQueue.main.async {
                            completion(signMsg.toHexString())
                        }
                        return
                    } catch {}
                }
            self.sendError(errorString: "Unable to sign message. Please make sure you have entered a correct private key.")
        }
    }
    
    // Method to verify signature of message for the private key
    func verifySignature(privateKey: String, message: String, signature: String, completion: @escaping (Bool) -> ()) {
        
        var isSuccess = false;
        DispatchQueue.global(qos: .background).async {
            if let walletAddress = self.getAddress(privateKey: privateKey) {
                do {
                    if let msgData = message.data(using: .utf8) {
                        let recoveredEthAddress = try self.web3.personal.ecrecover(personalMessage: msgData, signature: Data.init(hex: signature))
                            isSuccess = walletAddress == recoveredEthAddress
                    }
                } catch {}
            DispatchQueue.main.async {
                completion(isSuccess)
            }
        }
        }
    }
    // Method to send Error to caller view controller through delegate method in UI Thread
    func sendError(errorString: String) {
        DispatchQueue.main.async {
            self.delegate?.onError(error: ErrorResult.custom(errorDescription: errorString))
        }
    }

}
