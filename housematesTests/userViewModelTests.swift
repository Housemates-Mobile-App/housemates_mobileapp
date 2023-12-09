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
    var taskViewModel: TaskViewModel!

    override func setUpWithError() throws {
        testUsers = [
            User(id: "1", user_id: "user1", first_name: "Daniel", last_name: "Gunawan", is_home: false, phone_number: "123456", email: "dan@gmail.com", birthday: "10/05/2000", group_id: "2", imageURLString: "https://google.com/testImage.jpg"),
            User(id: "2", user_id: "user2", first_name: "john", last_name: "Gunawan", is_home: false, phone_number: "123456", email: "dan@gmail.com", birthday: "10/04/2000", group_id: "2", imageURLString: "https://google.com/testImage.jpg"),
            User(id: "3", user_id: "user3", first_name: "bob", last_name: "Gunawan", is_home: false, phone_number: "123456", email: "dan@gmail.com", birthday: "10/03/2000", group_id: "2", imageURLString: "https://google.com/testImage.jpg")
                ]
        viewModel = UserViewModel()
        taskViewModel = TaskViewModel()
    }

    override func tearDownWithError() throws {
        taskViewModel = nil
        viewModel = nil
        testUsers = nil
    }

    func testGetUserByID() {
        viewModel.users = testUsers
        let user = viewModel.getUserByID("1")

        XCTAssertNotNil(user)
        XCTAssertEqual(user?.id, "1")
        XCTAssertEqual(user?.first_name, "Daniel")
    }
    
    func testGetUserGroupmates() {
        viewModel.users = testUsers
        let groupmates = viewModel.getUserGroupmates("1")

        XCTAssertEqual(groupmates.count, testUsers.count - 1)
        XCTAssertFalse(groupmates.contains { $0.id == "1" })
    }
    
    func testGetUserGroupmatesInclusive() {
        viewModel.users = testUsers
        let groupmates = viewModel.getUserGroupmatesInclusive("1")

        XCTAssertEqual(groupmates.count, testUsers.count)
        XCTAssertTrue(groupmates.contains { $0.id == "1" })
    }
    
    func testGetUserGroupmatesInclusiveByTask() {
        viewModel.users = testUsers
        // Adding mock tasks to mockTaskViewModel for testing
        taskViewModel.tasks = [
            task(id: "task1", name: "Task 1", group_id: "2", user_id: "1", description: "", status: .done, date_completed: "date1", recurrence: .none),
            task(id: "task1a", name: "Task 1a", group_id: "2", user_id: "1", description: "", status: .inProgress, date_completed: "date1", recurrence: .none),
            task(id: "task2", name: "Task 2", group_id: "2", user_id: "2", description: "", status: .done, date_completed: "date2", recurrence: .none),
            task(id: "task2a", name: "Task 2a", group_id: "2", user_id: "2", description: "", status: .done, date_completed: "date2", recurrence: .none),
            task(id: "task3", name: "Task 3", group_id: "2", user_id: "3", description: "", status: .done, date_completed: "date3", recurrence: .none),
            task(id: "task4", name: "Task 4", group_id: "2", user_id: "3", description: "", status: .done, date_completed: "date3", recurrence: .none),
            task(id: "task5", name: "Task 5", group_id: "2", user_id: "3", description: "", status: .done, date_completed: "date3", recurrence: .none)
        ]

        let sortedGroupmates = viewModel.getUserGroupmatesInclusiveByTask("1", taskViewModel)

        XCTAssertEqual(sortedGroupmates[0].id, "3")
        XCTAssertEqual(sortedGroupmates[1].id, "2")
        XCTAssertEqual(sortedGroupmates[2].id, "1")
    }

    func testGetUserGroupmatesInclusiveByTaskTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yy h:mm a"
        let calendar = Calendar.current
        
        viewModel.users = testUsers

        taskViewModel.tasks = [
            task(id: "task1", name: "Task 1", group_id: "2", user_id: "1", description: "", status: .done, date_completed: dateFormatter.string(from: Date()), recurrence: .none),
            task(id: "task1", name: "Task 1", group_id: "2", user_id: "1", description: "", status: .inProgress, date_completed: "nil", recurrence: .none),
            task(id: "task2", name: "Task 2", group_id: "2", user_id: "2", description: "", status: .done, date_completed: dateFormatter.string(from: Date()), recurrence: .none),
            task(id: "task2b", name: "Task 2b", group_id: "2", user_id: "2", description: "", status: .done, date_completed: dateFormatter.string(from: Date()), recurrence: .none),
            task(id: "task3", name: "Task 3", group_id: "2", user_id: "3", description: "", status: .done, date_completed: dateFormatter.string(from: Date()), recurrence: .none),
            task(id: "task3b", name: "Task 3b", group_id: "2", user_id: "3", description: "", status: .done, date_completed: dateFormatter.string(from: Date()), recurrence: .none),
            task(id: "task3c", name: "Task 3c", group_id: "2", user_id: "3", description: "", status: .done, date_completed: dateFormatter.string(from: Date()), recurrence: .none),
        ]

        let sortedGroupmates = viewModel.getUserGroupmatesInclusiveByTaskTime("1", taskViewModel, timeframe: "Last Week")

        XCTAssertEqual(sortedGroupmates[0].id, "3")
        XCTAssertEqual(sortedGroupmates[1].id, "2")
        XCTAssertEqual(sortedGroupmates[2].id, "1")
    }
    
    func testGetGroupmateIndex() {
        // Test for existing user
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
