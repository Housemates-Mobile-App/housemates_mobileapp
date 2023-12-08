//
//  userViewModelTests.swift
//  housematesTests
//
//  Created by Daniel Gunawan on 12/7/23.
//

import XCTest
@testable import housemates

final class userViewModelTests: XCTestCase {
    var testUsers: [User]!
    var viewModel: UserViewModel!

    override func setUpWithError() throws {
        testUsers = [
            User(id: "1", user_id: "user1", first_name: "Daniel", last_name: "Gunawan", is_home: false, phone_number: "123456", email: "dan@gmail.com", birthday: "10/05/2000", group_id: "2", imageURLString: "https://google.com/testImage.jpg"),
            User(id: "2", user_id: "user2", first_name: "john", last_name: "Gunawan", is_home: false, phone_number: "123456", email: "dan@gmail.com", birthday: "10/04/2000", group_id: "2", imageURLString: "https://google.com/testImage.jpg"),
            User(id: "3", user_id: "user3", first_name: "bob", last_name: "Gunawan", is_home: false, phone_number: "123456", email: "dan@gmail.com", birthday: "10/03/2000", group_id: "2", imageURLString: "https://google.com/testImage.jpg")
                ]
        viewModel = UserViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        testUsers = nil
    }

    func testGetGroupmateIndex() {
        // Test for existing user
        print(testUsers!)
        if let index = viewModel.getGroupmateIndex("2", in: testUsers) {
            XCTAssertEqual(index, 1)
        } else {
            XCTFail("User ID should exist")
        }

        // Test for non-existing user
        let nonExistingIndex = viewModel.getGroupmateIndex("randomId", in: testUsers)
        XCTAssertNil(nonExistingIndex)
    }
    
    func testUserWithNextBirthday() {
        // Use fixed current date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let testCurrentDate = dateFormatter.date(from: "07-12-2023")!
        let nextBirthdayUser = viewModel.userWithNextBirthday(users: testUsers, currentDate: testCurrentDate)

        XCTAssertEqual(nextBirthdayUser?.user_id, "user3")
    }

}
