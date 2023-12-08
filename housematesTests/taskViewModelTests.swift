//
//  taskViewModelTests.swift
//  housematesTests
//
//  Created by Daniel Gunawan on 12/7/23.
//

import XCTest
@testable import housemates

final class taskViewModelTests: XCTestCase {
    var viewModel: TaskViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = TaskViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testGetTimestamp() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yy h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        let now = Date()
        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: now)!
        let thirtyMinutesAgo = Calendar.current.date(byAdding: .minute, value: -30, to: now)!
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!

        let oneHourAgoString = dateFormatter.string(from: oneHourAgo)
        let thirtyMinutesAgoString = dateFormatter.string(from: thirtyMinutesAgo)
        let yesterdayString = dateFormatter.string(from: yesterday)

        XCTAssertEqual(viewModel.getTimestamp(time: oneHourAgoString), "1h")
        XCTAssertEqual(viewModel.getTimestamp(time: thirtyMinutesAgoString), "30m")
        XCTAssertEqual(viewModel.getTimestamp(time: yesterdayString), "1d")
    }

    func testTaskNeedsReset() {
        let currentDate = Date()
        let calendar = Calendar.current

        let noCompletionDateTask = task(name: "wash dishes", group_id: "1", user_id: "1", description: "scrub it", status: task.Status.inProgress, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: calendar.date(byAdding: .day, value: -2, to: currentDate)!)
        let noRecurrenceStartDateTask = task(name: "walk dog", group_id: "1", user_id: "1", description: "scrub it", status: task.Status.inProgress, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil)
        let nonResetTask = task(name: "clean puke", group_id: "1", user_id: "1", description: "scrub it", status: task.Status.inProgress, date_completed: nil, priority: "high", recurrence: .none)
        let dailyTask = task(name: "clean toilet", group_id: "1", user_id: "1", description: "scrub it", status: task.Status.inProgress, date_completed: "testDateCompleted", priority: "high", recurrence: .daily, recurrenceStartDate: calendar.date(byAdding: .day, value: -2, to: currentDate)!)
        let weeklyTask = task(name: "take out trash", group_id: "1", user_id: "1", description: "scrub it", status: task.Status.inProgress, date_completed: "testDateCompleted", priority: "high", recurrence: .weekly, recurrenceStartDate: calendar.date(byAdding: .weekOfYear, value: -2, to: currentDate)!)
        
        XCTAssertFalse(viewModel.taskNeedsReset(task: noCompletionDateTask, currentDate: currentDate))
        XCTAssertFalse(viewModel.taskNeedsReset(task: noRecurrenceStartDateTask, currentDate: currentDate))
        XCTAssertFalse(viewModel.taskNeedsReset(task: nonResetTask, currentDate: currentDate))
        
        XCTAssertTrue(viewModel.taskNeedsReset(task: dailyTask, currentDate: currentDate))
        XCTAssertTrue(viewModel.taskNeedsReset(task: weeklyTask, currentDate: currentDate))
    }

}
