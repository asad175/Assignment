//
//  AccountViewModelTest.swift
//  AssignmentTests
//
//  Created by Asad Choudhary on 1/30/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import XCTest
@testable import Assignment

class AccountViewModelTest: XCTestCase {
    
    var viewModel : AccountViewModel!
    fileprivate var accountDelegate: MockAccountView!
    
    var privateKey = "CF02C73D0BDBFD92864D51F8F2238919AB29CE5612CCCBADC2FE6DF8D1ACAAAE";
    var address = "0xb6f038946473d47d4B29c05e788efb3736BA3Dd0";
    var balance = 3.0

    override func setUp() {
        super.setUp()
        accountDelegate = MockAccountView()
        let userWallet = Wallet.init(privateKey: privateKey, address: address, balance: balance)
        self.viewModel = AccountViewModel.init(userWallet: userWallet)
        self.viewModel.delegate = accountDelegate;
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.accountDelegate = nil
        super.tearDown()
    }
    
    func testGetMessageInputViewModel() {
        
        let expectation = XCTestExpectation(description: "AccountViewModel returns MessageInputViewModel Object")
         XCTAssert(viewModel.messageInputViewModel() != nil)
         expectation.fulfill()
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testInitializations() {
        
        let expectation = XCTestExpectation(description: "AccountViewModel calls updateAccountDetails when initialized")
        accountDelegate.updateAccountDetailsClosure = { (address, balance) in
            XCTAssertEqual(address, self.address)
            XCTAssertEqual(balance, String(self.balance) + " Ether")
            expectation.fulfill()
        }
        viewModel.initializations()
        wait(for: [expectation], timeout: 5.0)
    }
   
}


fileprivate class MockAccountView : AccountViewModelDelegate {
    
    var updateAccountDetailsClosure: ((_ address: String, _ balance: String) -> Void)!
    
    func updateAccountDetails(address: String, balance: String) {
        updateAccountDetailsClosure(address, balance)
    }
}
