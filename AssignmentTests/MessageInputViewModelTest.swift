//
//  MessageInputViewModelTest.swift
//  AssignmentTests
//
//  Created by Asad Choudhary on 1/30/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import XCTest
@testable import Assignment

class MessageInputViewModelTest: XCTestCase {
    
    var viewModel : MessageInputViewModel!
    fileprivate var messageInputDelegate: MockMessageInputView!
    let userWallet = Wallet(privateKey: "CF02C73D0BDBFD92864D51F8F2238919AB29CE5612CCCBADC2FE6DF8D1ACAAAE", address: "0xb6f038946473d47d4B29c05e788efb3736BA3Dd0", balance: 3.0)
    
    override func setUp() {
        super.setUp()
        messageInputDelegate = MockMessageInputView()
        self.viewModel = MessageInputViewModel.init(userWallet: userWallet)
        self.viewModel.delegate = messageInputDelegate
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.messageInputDelegate = nil
        super.tearDown()
    }
    
    func testValidateMessage() {
        
        let expectation = XCTestExpectation(description: "MessageInputViewModel calls onEmptyInput delegate method when message is empty")
        messageInputDelegate.onEmptyInputClosure = {
            expectation.fulfill()
        }
        viewModel.validateMessage(message: nil)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCheckForVerificationValidity() {
        
        let expectation = XCTestExpectation(description: "MessageInputViewModel calls onSuccess delegate method when input is valid")
        messageInputDelegate.onSuccessClosure = {
            expectation.fulfill()
        }
        viewModel.checkForVerificationValidity(message: "Hello")
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSignMessageWithEmptyInput() {
        
        let expectation = XCTestExpectation(description: "MessageInputViewModel calls onEmptyInput delegate method when message is empty")
        messageInputDelegate.onEmptyInputClosure = {
            expectation.fulfill()
        }
        viewModel.signMessage(message: nil)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSignMessageWithCorrectInput() {
        
        let expectation = XCTestExpectation(description: "MessageInputViewModel calls onSuccess delegate method and update signature in viewModel object when message signature is done")
        messageInputDelegate.onSuccessClosure = {
            XCTAssertEqual(self.viewModel.signature, "2e1e3eb817d4489b1b5487e8f7c85e0ea7be71b96f0f69ecf9579b24e176617f2a632585c4a008ce4f67f54c928f7b824ebfac00020e07b67c99d1119b7e3bb71b") // expected signature
            expectation.fulfill()
        }
        viewModel.signMessage(message: "Hello")
        wait(for: [expectation], timeout: 5.0)
    }
  
}


fileprivate class MockMessageInputView : MessageInputViewModelDelegate {
    var onSuccessClosure: (() -> Void)!
    var onErrorClosure: ((ErrorResult?) -> Void)!
    var onEmptyInputClosure: (() -> Void)!
    
    func onSuccess() {
        onSuccessClosure()
    }
    
    func onError(error: ErrorResult?) {
        onErrorClosure(error)
    }
    
    func onEmptyInput() {
        onEmptyInputClosure()
    }
}
