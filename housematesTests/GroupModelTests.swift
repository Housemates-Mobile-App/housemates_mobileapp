//
//  GroupModelTests.swift
//  housematesTests
//
//  Created by Daniel Fransesco Gunawan on 11/8/23.
//

import XCTest
@testable import housemates

final class GroupModelTests: XCTestCase {

    var testGroup1 : Group!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testGroup1 = Group(address: "100 Centre Ave", name: "Cool House", code: "1234")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        testGroup1 = nil
    }
    
    func testInitializeGroup() {
        XCTAssertEqual(testGroup1.address, "100 Centre Ave")
        XCTAssertEqual(testGroup1.name, "Cool House")
        XCTAssertEqual(testGroup1.code, "1234")
    }

}
