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
    var testTasks: [task]!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = TaskViewModel()
        testTasks = [
            task(id: "1", name: "task1", group_id: "1", user_id: "1", description: "scrub it", status: task.Status.inProgress, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "2", name: "task2", group_id: "2", user_id: "2", description: "scrub it", status: task.Status.inProgress, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "3", name: "task3", group_id: "1", user_id: "3", description: "scrub it", status: task.Status.inProgress, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
        ]
        viewModel.tasks = testTasks
    }

    override func tearDownWithError() throws {
        testTasks = nil
        viewModel = nil
    }
    
    func testGetUserIdByTaskId() {
        let userIdOfTaskId1 = viewModel.getUserIdByTaskId("1")

        XCTAssertEqual(userIdOfTaskId1, "1")
    }
    
    func testGetTasksForGroup() {
        // Call getTasksForGroup
        let group1Tasks = viewModel.getTasksForGroup("1")

        XCTAssertEqual(group1Tasks.count, 2, "Expected 2 tasks for group id 1")
        for task in group1Tasks {
            XCTAssertEqual(task.group_id, "1", "Task should have group id 1")
        }
        
    }
    
    func testGetUnclaimedTasksForGroup() {
        let tempTasks = [
            task(id: "4", name: "task4", group_id: "3", user_id: "4", description: "scrub it", status: task.Status.unclaimed, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "5", name: "task5", group_id: "3", user_id: "5", description: "scrub it", status: task.Status.unclaimed, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "6", name: "task6", group_id: "3", user_id: "5", description: "scrub it", status: task.Status.inProgress, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
        ]
        viewModel.tasks = tempTasks
        
        let unclaimedTasks = viewModel.getUnclaimedTasksForGroup("3")

        for task in unclaimedTasks {
            XCTAssertEqual(task.group_id, "3")
            XCTAssertEqual(task.status, .unclaimed)
        }
    }
    
    func testGetInProgressTasksForGroup() {
        let tempTasks = [
            task(id: "4", name: "task4", group_id: "3", user_id: "4", description: "scrub it", status: task.Status.unclaimed, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "5", name: "task5", group_id: "3", user_id: "5", description: "scrub it", status: task.Status.unclaimed, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "6", name: "task6", group_id: "3", user_id: "5", description: "scrub it", status: task.Status.inProgress, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
        ]
        
        viewModel.tasks = tempTasks
        
        let inProgressTasks = viewModel.getInProgressTasksForGroup("3")

        for task in inProgressTasks {
            XCTAssertEqual(task.group_id, "3")
            XCTAssertEqual(task.status, .inProgress)
        }
    }
    
    func testGetCompletedTasksForGroup() {
        let tempTasks = [
            task(id: "4", name: "task4", group_id: "3", user_id: "4", description: "scrub it", status: task.Status.unclaimed, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "5", name: "task5", group_id: "3", user_id: "5", description: "scrub it", status: task.Status.unclaimed, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "6", name: "task6", group_id: "3", user_id: "5", description: "scrub it", status: task.Status.done, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
        ]
        
        viewModel.tasks = tempTasks
        
        let completedTasks = viewModel.getCompletedTasksForGroup("3")

        for task in completedTasks {
            XCTAssertEqual(task.group_id, "3")
            XCTAssertEqual(task.status, .done)
        }
    }
    
    func testGetCompletedTasksForUser() {
        let tempTasks = [
            task(id: "4", name: "task4", group_id: "3", user_id: "4", description: "scrub it", status: task.Status.unclaimed, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "5", name: "task5", group_id: "3", user_id: "5", description: "scrub it", status: task.Status.unclaimed, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "6", name: "task6", group_id: "3", user_id: "5", description: "scrub it", status: task.Status.done, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
        ]
        
        viewModel.tasks = tempTasks

        let completedTasks = viewModel.getCompletedTasksForUser("5")

        for task in completedTasks {
            XCTAssertEqual(task.user_id, "5")
            XCTAssertEqual(task.status, .done)
        }
    }
    
    func testGetPendingTasksForUser() {
        let tempTasks = [
            task(id: "4", name: "task4", group_id: "3", user_id: "4", description: "scrub it", status: task.Status.unclaimed, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "5", name: "task5", group_id: "3", user_id: "5", description: "scrub it", status: task.Status.unclaimed, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "6", name: "task6", group_id: "3", user_id: "5", description: "scrub it", status: task.Status.inProgress, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
        ]
        
        viewModel.tasks = tempTasks
        
        let pendingTasks = viewModel.getPendingTasksForUser("5")

        for task in pendingTasks {
            XCTAssertEqual(task.user_id, "5")
            XCTAssertEqual(task.status, .inProgress)
        }
    }
    
    func testGetRecentCompletedTasksForUser() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yy h:mm a"
        let calendar = Calendar.current

        // Assuming today's date is fixed for the purpose of testing
        let fixedCurrentDate = dateFormatter.date(from: "12.07.2023 12:00 PM")!

        // Set up mock completed tasks
        let taskCompletedYesterday = task(id: "1", name: "Task1", group_id: "1", user_id: "1", description: "Task completed yesterday", status: .done, date_completed: dateFormatter.string(from: calendar.date(byAdding: .day, value: -1, to: fixedCurrentDate)!), priority: "high", recurrence: .none, recurrenceStartDate: nil)
        let taskCompleted8DaysAgo = task(id: "2", name: "Task2", group_id: "1", user_id: "1", description: "Task completed 8 days ago", status: .done, date_completed: dateFormatter.string(from: calendar.date(byAdding: .day, value: -8, to: fixedCurrentDate)!), priority: "high", recurrence: .none, recurrenceStartDate: nil)
        let taskCompletedSameDay = task(id: "3", name: "Task3", group_id: "1", user_id: "1", description: "Task completed today", status: .done, date_completed: dateFormatter.string(from: fixedCurrentDate), priority: "high", recurrence: .none, recurrenceStartDate: nil)

        viewModel.tasks = [taskCompletedYesterday, taskCompleted8DaysAgo, taskCompletedSameDay]

        let recentCompletedTasks = viewModel.getRecentCompletedTasksForUser("1", currentDate: fixedCurrentDate)

        XCTAssertTrue(recentCompletedTasks.contains { $0.id == taskCompletedYesterday.id })
        XCTAssertFalse(recentCompletedTasks.contains { $0.id == taskCompleted8DaysAgo.id })
        XCTAssertTrue(recentCompletedTasks.contains { $0.id == taskCompletedSameDay.id })
    }
    
    func testGetNumPendingTasksForUser() {
        let tempTasks = [
            task(id: "4", name: "task4", group_id: "3", user_id: "4", description: "scrub it", status: task.Status.unclaimed, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "5", name: "task5", group_id: "3", user_id: "5", description: "scrub it", status: task.Status.unclaimed, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "6", name: "task6", group_id: "3", user_id: "5", description: "scrub it", status: task.Status.inProgress, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
        ]
        
        viewModel.tasks = tempTasks
        
        let numPendingTasks = viewModel.getNumPendingTasksForUser("5")

        XCTAssertEqual(numPendingTasks, 1)
    }
    
    func testGetNumCompletedTasksForUser() {
        let tempTasks = [
            task(id: "4", name: "task4", group_id: "3", user_id: "4", description: "scrub it", status: task.Status.unclaimed, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "5", name: "task5", group_id: "3", user_id: "5", description: "scrub it", status: task.Status.unclaimed, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "6", name: "task6", group_id: "3", user_id: "5", description: "scrub it", status: task.Status.done, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
        ]
        
        viewModel.tasks = tempTasks
        
        let numCompletedTasks = viewModel.getNumCompletedTasksForUser("5")

        XCTAssertEqual(numCompletedTasks, 1)
    }
    
    func testGetNumCompletedTasksForGroup() {
        let tempTasks = [
            task(id: "4", name: "task4", group_id: "3", user_id: "4", description: "scrub it", status: task.Status.done, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "5", name: "task5", group_id: "3", user_id: "5", description: "scrub it", status: task.Status.unclaimed, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
            task(id: "6", name: "task6", group_id: "3", user_id: "5", description: "scrub it", status: task.Status.done, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil),
        ]
        
        viewModel.tasks = tempTasks
        let numCompletedTasks = viewModel.getNumCompletedTasksForGroup("3")

        XCTAssertEqual(numCompletedTasks, 2)
    }
    
    func testIsMyTask() {
        let task = task(id: "6", name: "task6", group_id: "3", user_id: "5", description: "scrub it", status: task.Status.done, date_completed: nil, priority: "high", recurrence: .daily, recurrenceStartDate: nil)
        let isTaskOfUserA = viewModel.isMyTask(task: task, user_id: "5")
        let isTaskOfUserB = viewModel.isMyTask(task: task, user_id: "1")

        // Check if the function correctly identifies the user's task
        XCTAssertEqual(isTaskOfUserA, true)
        XCTAssertEqual(isTaskOfUserB, false)
    }
    
    func testGetCompletedTasksForUserByDay() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yy h:mm a"
        let calendar = Calendar.current

        // mock tasks
        let taskCompletedToday = task(id: "1", name: "Today Task", group_id: "1", user_id: "1", description: "Completed Today", status: .done, date_completed: dateFormatter.string(from: Date()), priority: "high", recurrence: .none, recurrenceStartDate: nil)
        let taskCompletedLastWeek = task(id: "2", name: "Last Week Task", group_id: "1", user_id: "1", description: "Completed Last Week", status: .done, date_completed: dateFormatter.string(from: calendar.date(byAdding: .day, value: -6, to: Date())!), priority: "high", recurrence: .none, recurrenceStartDate: nil)

        viewModel.tasks = [taskCompletedToday, taskCompletedLastWeek]

        let tasksCompletedToday = viewModel.getCompletedTasksForUserByDay("1", timeframe: "Today")
        XCTAssertTrue(tasksCompletedToday.contains { $0.id == taskCompletedToday.id })

        let tasksCompletedLastWeek = viewModel.getCompletedTasksForUserByDay("1", timeframe: "Last Week")
        XCTAssertTrue(tasksCompletedLastWeek.contains { $0.id == taskCompletedLastWeek.id })
    }
    
    func testGetCompletedTasksForGroupByDay() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yy h:mm a"
        let calendar = Calendar.current

        // mock tasks
        let taskCompletedToday = task(id: "1", name: "Today Task", group_id: "1", user_id: "1", description: "Completed Today", status: .done, date_completed: dateFormatter.string(from: Date()), priority: "high", recurrence: .none, recurrenceStartDate: nil)
        let taskCompletedLastMonth = task(id: "2", name: "Last Month Task", group_id: "1", user_id: "1", description: "Completed Last Month", status: .done, date_completed: dateFormatter.string(from: calendar.date(byAdding: .day, value: -25, to: Date())!), priority: "high", recurrence: .none, recurrenceStartDate: nil)

        viewModel.tasks = [taskCompletedToday, taskCompletedLastMonth]

        let tasksCompletedToday = viewModel.getCompletedTasksForGroupByDay("1", timeframe: "Today")
        XCTAssertTrue(tasksCompletedToday.contains { $0.id == taskCompletedToday.id })

        let tasksCompletedLastMonth = viewModel.getCompletedTasksForGroupByDay("1", timeframe: "Last Month")
        XCTAssertTrue(tasksCompletedLastMonth.contains { $0.id == taskCompletedLastMonth.id })
    }

    func testGetTimestamp() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yy h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        let now = Date()
        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: now)!
        let oneSecondAgo = Calendar.current.date(byAdding: .second, value: -1, to: now)!
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!

        let oneHourAgoString = dateFormatter.string(from: oneHourAgo)
        let oneSecondAgoString = dateFormatter.string(from: oneSecondAgo)
        let yesterdayString = dateFormatter.string(from: yesterday)

        XCTAssertEqual(viewModel.getTimestamp(time: oneHourAgoString), "1h")
        XCTAssertEqual(viewModel.getTimestamp(time: oneSecondAgoString), "<1m")
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
