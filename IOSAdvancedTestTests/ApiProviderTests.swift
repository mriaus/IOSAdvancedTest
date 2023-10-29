//
//  ApiProviderTests.swift
//  IOSAdvancedTestTests
//
//  Created by Marcos on 28/10/23.
//

import XCTest
@testable import IOSAdvancedTest

final class ApiProviderTests: XCTestCase {
    private var sut: ApiProviderProtocol!
    
    override func setUp() {
        sut = MockApiProvider(secureDataProvider: SecureDataProvider())
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_givenApiProvider_whenLoginWithUserAndPassword_then_getValidToken() throws {
        let handler: (Notification) -> Bool = { notification in
                   let token = notification.userInfo?[NotificationCenter.TOKENKEY] as? String
                   XCTAssertNotNil(token)
                   XCTAssertNotEqual(token ?? "", "")

                   return true
               }
        let expectation = self.expectation(
                   forNotification: NotificationCenter.APILOGINNOTIFICATION,
                   object: nil,
                   handler: handler
               )
        sut.login(for: "testMail", with: "testPassword")
                wait(for: [expectation], timeout: 10.0)
    }
    
    func test_givenApiProvider_whenLoginWithUserAndButNotPassword_then_NotGetToken() throws {
        let handler: (Notification) -> Bool = { notification in
                   let token = notification.userInfo?[NotificationCenter.TOKENKEY] as? String
                   XCTAssertEqual(token ?? "", "")
                   return true
               }
        let expectation = self.expectation(
                   forNotification: NotificationCenter.APILOGINNOTIFICATION,
                   object: nil,
                   handler: handler
               )
        sut.login(for: "", with: "")
                wait(for: [expectation], timeout: 10.0)
    }
    
    func test_givenApiProvider_whenGetAllCharacters_ThenCharactersExists() throws {
        let expectation = self.expectation(description: "Fetch all characters data")
        
        sut.getCharacters(by: nil, token: "", completion: { characters in
            XCTAssertNotEqual(characters.count, 0)
            print(characters)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }
    func test_givenApiProvider_whenGiveAName_ThenJustTheCharacterReturns() throws {
        let expectation = self.expectation(description: "Fetch a character data")
        
        sut.getCharacters(by: "Goku", token: "", completion: { characters in
            XCTAssertEqual(characters.count, 1)
            XCTAssertEqual(characters[0].name, "Goku")
            print(characters)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_givenApiProvider_WhenGiveABadName_ThenReturnsEmptyData() throws {
        let expectation = self.expectation(description: "Dont fetch data")
        
        sut.getCharacters(by: "NotExist", token: "", completion: { characters in
            XCTAssertEqual(characters.count, 0)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_givenApiProvider_WhenGiveAnID_ThenReturnsTheLocations() throws {
        let expectation = self.expectation(description: "Return all the data")
        
        sut.getLocations(by: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94" , token: "") { locations in
            XCTAssertGreaterThan(locations.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_givenApiProvider_WhenGivenAnInvalidID_ThenReturnsEmpty() throws {
        let expectation = self.expectation(description: "Returns empty data")
        
        sut.getLocations(by: "" , token: "") { locations in
            XCTAssertEqual(locations.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
