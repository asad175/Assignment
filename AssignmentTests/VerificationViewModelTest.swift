//
//  VerificationViewModelTest.swift
//  AssignmentTests
//
//  Created by Asad Choudhary on 1/30/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import XCTest
@testable import Assignment

class VerificationViewModelTest: XCTestCase {
    
    var viewModel : VerificationViewModel!
    fileprivate var verificationViewDelegate: MockVerificationView!
    let userWallet = Wallet(privateKey: "CF02C73D0BDBFD92864D51F8F2238919AB29CE5612CCCBADC2FE6DF8D1ACAAAE", address: "0xb6f038946473d47d4B29c05e788efb3736BA3Dd0", balance: 3.0)
    
    override func setUp() {
        super.setUp()
        verificationViewDelegate = MockVerificationView()
        self.viewModel = VerificationViewModel.init(userWallet: userWallet, message: "Hello")
        self.viewModel.delegate = verificationViewDelegate
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.verificationViewDelegate = nil
        super.tearDown()
    }
    
    func testVerifySignatureWithWrongInput() {
        
        let expectation = XCTestExpectation(description: "VerificationViewModel calls onFailure delegate method when signature is not verified")
        verificationViewDelegate.onFailureClosure = {
            expectation.fulfill()
        }
        viewModel.verifySignature(signature: "wrong signature")
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testVerifySignatureWithCorrectInput() {
        
        let expectation = XCTestExpectation(description: "VerificationViewModel calls onSuccess delegate method when signature is verified")
        verificationViewDelegate.onSuccessClosure = {
            expectation.fulfill()
        }
        verificationViewDelegate.onFailureClosure = {
        }
        viewModel.verifySignature(signature: "2e1e3eb817d4489b1b5487e8f7c85e0ea7be71b96f0f69ecf9579b24e176617f2a632585c4a008ce4f67f54c928f7b824ebfac00020e07b67c99d1119b7e3bb71b")
        wait(for: [expectation], timeout: 5.0)
    }
  
}


fileprivate class MockVerificationView : VerificationViewDelegate {

    var onSuccessClosure: (() -> Void)!
    var onErrorClosure: ((ErrorResult?) -> Void)!
    var onFailureClosure: (() -> Void)!
    
    func onSuccess() {
        onSuccessClosure()
    }
    
    func onError(error: ErrorResult?) {
        onErrorClosure(error)
    }
    
    func onFailure() {
        onFailureClosure()
    }
}
