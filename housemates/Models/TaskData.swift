//
//  TaskData.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/10/23.
//

import Foundation

// for taskSelection
struct TaskData {
    var taskIcon: String
    var taskName: String
}

let hardcodedHouseworkTaskData: [TaskData] = [
    TaskData(taskIcon: "dishe", taskName: "Wash Dishes"),
    TaskData(taskIcon: "oven", taskName: "Clean Kitchen"),
    TaskData(taskIcon: "dining", taskName: "Wipe Dining Table"),
    TaskData(taskIcon: "trash", taskName: "Take out Trash"),
    TaskData(taskIcon: "dust", taskName: "Sweep Floor"),
    TaskData(taskIcon: "sun", taskName: "Vacuum Ground"),
]

let hardcodedIndoorTaskData: [TaskData] = [
    TaskData(taskIcon: "recycle", taskName: "Recycle"),
    TaskData(taskIcon: "living room", taskName: "Clean Living Room"),
    TaskData(taskIcon: "fridge", taskName: "Clean Fridge"),
    TaskData(taskIcon: "toilet", taskName: "Scrub Toilet"),
    TaskData(taskIcon: "shop", taskName: "Restock Paper"),
    TaskData(taskIcon: "tub", taskName: "Clean Shower"),
]

let hardcodedOutdoorTaskData: [TaskData] = [
    TaskData(taskIcon: "laundry", taskName: "Do Laundry"),
    TaskData(taskIcon: "shop", taskName: "Get Groceries"),
    TaskData(taskIcon: "chef", taskName: "Prep Meals"),
    TaskData(taskIcon: "bills", taskName: "Pay Bills"),
    TaskData(taskIcon: "car", taskName: "Wash Car"),
    TaskData(taskIcon: "moon", taskName: "Dust Chairs"),
]

// for task chart
struct TaskDataPoint : Identifiable {
    var id = UUID().uuidString
    var day: String
    var totalTasks: Int
}

let hardcodedTaskDataPoints: [TaskDataPoint] = [
    TaskDataPoint(day: "Sun", totalTasks: 3),
    TaskDataPoint(day: "Mon", totalTasks: 5),
    TaskDataPoint(day: "Tue", totalTasks: 7),
    TaskDataPoint(day: "Wed", totalTasks: 2),
    TaskDataPoint(day: "Thu", totalTasks: 1),
    TaskDataPoint(day: "Fri", totalTasks: 3),
    TaskDataPoint(day: "Sat", totalTasks: 4)
]
