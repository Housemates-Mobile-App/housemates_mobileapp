//
//  commentModelTests.swift
//  housematesTests
//
//  Created by Daniel Fransesco Gunawan on 11/8/23.
//

import XCTest
@testable import housemates

final class CommentModelTests: XCTestCase {
    
    var testUser1 : User!
    var testComment1 : Comment!
    var currentDate = Date()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testUser1 = User(first_name: "Daniel", last_name: "Gunawan", phone_number: "123456", email: "dan@gmail.com", birthday: "10/10/2000")
        testComment1 = Comment(text: 31, date_created: currentDate, created_by: testUser1)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        testComment1 = nil
        testUser1 = nil
    }
    
    func testInitializeComment() {
        XCTAssertEqual(testComment1.text, 31)
        XCTAssertEqual(testComment1.date_created, currentDate)
        XCTAssertEqual(testComment1.created_by.first_name, "Daniel")
    }

}
