//
//  StarteriOSTests.swift
//  StarteriOSTests
//
//  Created by Nagesh Kumar Mishra on 13/03/23.
//

import XCTest
@testable import StarteriOS

final class StarteriOSTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // Check response is not nil 
    func testResponse() throws {
       let cardsViewModel = CardsViewModel()
         cardsViewModel.bindViewModelToController = {
             XCTAssertNotNil(cardsViewModel.cardModel?.cards)
        }
    }
    
    // Check url generation is right
    func testGetCardURLGeneration() {
        let endpoint = Endpoint.getCards
        let request = endpoint.url
        XCTAssertEqual(request, URL(string: "https://mocki.io/v1/e93144a0-0c50-4cb4-b13b-f031613fe61e?"))
    }
    

}
