//
//  SetupViewModelTest.swift
//  AssignmentTests
//
//  Created by Asad Choudhary on 1/30/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import XCTest
@testable import Assignment

class SetupViewModelTest: XCTestCase {
    
    var viewModel : SetupViewModel!
    fileprivate var setupDelegate: MockSetupView!
    
    override func setUp() {
        super.setUp()
        setupDelegate = MockSetupView()
        self.viewModel = SetupViewModel.init(delegate: setupDelegate)
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.setupDelegate = nil
        super.tearDown()
    }
    
    func testGetAccountDetailsWithEmptyInput() {
        
        let expectation = XCTestExpectation(description: "SetupViewModel calls onEmptyInput delegate method when private key is empty")
        setupDelegate.onEmptyInputClosure = {
            expectation.fulfill()
        }
        
        viewModel.getAccountDetails(privateKey: nil)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetAccountDetailsWithWrongPrivateKey() {
        
        let expectation = XCTestExpectation(description: "SetupViewModel calls onError delegate method when private key is wrong")
        let expectedError = ErrorResult.custom(errorDescription: "Unable to find account details. Please make sure you have entered a correct private key.")
        setupDelegate.onErrorClosure = { error in
            XCTAssertEqual(error, expectedError)
            expectation.fulfill()
        }
        
        viewModel.getAccountDetails(privateKey: "CF02C") // wrong private key
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetAccountDetailsWithCorrectPrivateKey() {
        
        let expectation = XCTestExpectation(description: "SetupViewModel calls onSuccess delegate method when private key is correct")
        setupDelegate.onSuccessClosure = {
            XCTAssertEqual(self.viewModel.userWallet?.address, "0xb6f038946473d47d4B29c05e788efb3736BA3Dd0") // address associated to entered private key
            XCTAssertEqual(self.viewModel.userWallet?.balance, 3.0) // balance associated to entered private key
            expectation.fulfill()
        }
        
        viewModel.getAccountDetails(privateKey: "CF02C73D0BDBFD92864D51F8F2238919AB29CE5612CCCBADC2FE6DF8D1ACAAAE") // correct private key
        wait(for: [expectation], timeout: 5.0)
    }
    
}


fileprivate class MockSetupView : SetupViewModelDelegate {
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
