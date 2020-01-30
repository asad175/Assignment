//
//  AccountViewController.swift
//  Assignment
//
//  Created by Asad Choudhary on 1/26/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, AccountViewModelDelegate {
    

    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelBalance: UILabel!
    @IBOutlet weak var btSign: UIButton!
    @IBOutlet weak var btVerify: UIButton!
    
    var viewModel : AccountViewModel?
    
    let SignActionSegueIdentifier = "signAction"
    let VerifyActionSegueIdentifier = "verifyAction"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializations()
    }
    

   func initializations() {
       self.navigationItem.title = "Account";
       viewModel?.initializations()
   }
    
    // Delegate Method
    func updateAccountDetails(address: String, balance: String) {
        labelAddress.text = address
        labelBalance.text = balance
        btSign.isEnabled = true
        btVerify.isEnabled = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // pass data to MessageInputViewModel
        if (segue.identifier == SignActionSegueIdentifier || segue.identifier == VerifyActionSegueIdentifier) {
             if let vc = segue.destination as? MessageInputViewController {
                vc.viewModel = self.viewModel?.messageInputViewModel();
                vc.viewModel?.delegate = vc;
                vc.type = segue.identifier == SignActionSegueIdentifier ? .sign : .verify
            }
        }
    }
    
}
