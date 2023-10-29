//
//  SecureDataProviderTest.swift
//  IOSAdvancedTestTests
//
//  Created by Marcos on 28/10/23.
//

import XCTest
@testable import IOSAdvancedTest

final class SecureDataProvideTests: XCTestCase {
    private var sut: SecureDataProviderProtocol!

    override func setUp() {
        sut = SecureDataProvider()
    }

    func test_givenSecureDataProvider_whenLoadToken_thenGetStoredToken() throws {

        let token = "tokenTest"
        sut.save(token: token)
        let tokenLoaded = sut.getToken()

        XCTAssertEqual(token, tokenLoaded)

    }
    
    func test_givenSecureDataProvider_whenToken_thenReplaceTheOldToken() throws {
        let token = "tokenTestRemove"
        sut.save(token: token)
        
        sut.save(token: "")
        let newToken = sut.getToken()
        XCTAssertNotEqual(token, newToken)
        
    }
}
