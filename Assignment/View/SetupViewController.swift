//
//  ViewController.swift
//  Assignment
//
//  Created by Asad Choudhary on 1/25/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import UIKit



class SetupViewController: UIViewController {
    
    @IBOutlet weak var tfPrivateKey: UITextField!
    
    lazy var viewModel : SetupViewModel = {
        let viewModel = SetupViewModel(delegate: self)
        return viewModel
    }()

    let ShowAccountSegueIdentifier = "showAccount"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        initializations()
    }
    
    func initializations() {
        self.navigationItem.title = "Setup";
        tfPrivateKey.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // pass data to AccountViewModel
        if (segue.identifier == ShowAccountSegueIdentifier) {
             if let nv = segue.destination as? UINavigationController,
                let vc = nv.topViewController as? AccountViewController {
                    vc.viewModel = self.viewModel.accountViewModel();
                    vc.viewModel?.delegate = vc;
            }
        }
    }
    
}

extension SetupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.getAccountDetails(privateKey: textField.text) // Get account details by clicking on keyboard return key
        textField.resignFirstResponder()
        return true
    }
}

extension SetupViewController: SetupViewModelDelegate {

    func onSuccess() { // Success in getting account details from private key
        tfPrivateKey.resignFirstResponder()
        self.performSegue(withIdentifier: ShowAccountSegueIdentifier, sender: self)
    }
    // Error Handler
    func onError(error: ErrorResult?) {
        Utils.showSimpleAlert(controller: self, title: "An error occured", message: error?.localizedDescription, buttonText: "Cancel")
    }
    
    func onEmptyInput() {
        tfPrivateKey.shake()
    }
}
