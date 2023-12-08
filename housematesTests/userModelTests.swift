//
//  userModelTests.swift
//  housematesTests
//
//  Created by Daniel Fransesco Gunawan on 11/8/23.
//

import XCTest
@testable import housemates

final class UserModelTest: XCTestCase {
    var testUser1 : User!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testUser1 = User(user_id: "1", first_name: "Daniel", last_name: "Gunawan", is_home: false, phone_number: "123456", email: "dan@gmail.com", birthday: "10/10/2000", group_id: "2", imageURLString: "https://google.com/testImage.jpg")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        testUser1 = nil
    }
    
    func testInitializeUser() {
        XCTAssertEqual(testUser1.user_id, "1")
        XCTAssertEqual(testUser1.first_name, "Daniel")
        XCTAssertEqual(testUser1.last_name, "Gunawan")
        XCTAssertEqual(testUser1.is_home, false)
        XCTAssertEqual(testUser1.phone_number, "123456")
        XCTAssertEqual(testUser1.email, "dan@gmail.com")
        XCTAssertEqual(testUser1.birthday, "10/10/2000")
        XCTAssertEqual(testUser1.group_id, "2")
        XCTAssertEqual(testUser1.imageURLString, "https://google.com/testImage.jpg")
    }
}
