//
//  taskModelTests.swift
//  housematesTests
//
//  Created by Daniel Fransesco Gunawan on 11/8/23.
//

import XCTest
@testable import housemates

final class TaskModelTests: XCTestCase {

    var testTask1 : task!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testTask1 = task(name: "clean toilet", group_id: "1", user_id: "1", description: "scrub it", status: task.Status.inProgress, date_started: "10/10/2021", date_completed: "10/11/2021", priority: "high")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        testTask1 = nil
    }
    
    func testInitializeTask() {
        XCTAssertEqual(testTask1.name, "clean toilet")
        XCTAssertEqual(testTask1.group_id, "1")
        XCTAssertEqual(testTask1.user_id, "1")
        XCTAssertEqual(testTask1.description, "scrub it")
        XCTAssertEqual(testTask1.status, task.Status.inProgress)
        XCTAssertEqual(testTask1.date_started, "10/10/2021")
        XCTAssertEqual(testTask1.date_completed, "10/11/2021")
        XCTAssertEqual(testTask1.priority, "high")
    }

}
