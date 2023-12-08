//
//  TaskData.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/10/23.
//

import Foundation

// for taskSelection
struct TaskData : Hashable {
    var taskIcon: String
    var taskName: String
    var taskCategory: String?
}

let hardcodedHouseworkTaskData: [TaskData] = [
    TaskData(taskIcon: "dishe", taskName: "Wash Dishes"),
    TaskData(taskIcon: "oven", taskName: "Clean Kitchen"),
    TaskData(taskIcon: "dining", taskName: "Wipe Table"),
    TaskData(taskIcon: "trash", taskName: "Take out Trash"),
    TaskData(taskIcon: "dust", taskName: "Sweep Floor"),
    TaskData(taskIcon: "dust", taskName: "Sweep Floor"),
]

let hardcodedIndoorTaskData: [TaskData] = [
    TaskData(taskIcon: "recycle", taskName: "Recycle"),
    TaskData(taskIcon: "chef", taskName: "Prep Meals"),
    TaskData(taskIcon: "fridge", taskName: "Clean Fridge"),
    TaskData(taskIcon: "toilet", taskName: "Scrub Toilet"),
    TaskData(taskIcon: "laundry", taskName: "Do Laundry"),
    TaskData(taskIcon: "tub", taskName: "Clean Shower"),
]

let hardcodedOutdoorTaskData: [TaskData] = [
    TaskData(taskIcon: "plants", taskName: "Water Plants"),
    TaskData(taskIcon: "shopping", taskName: "Get Groceries"),
    TaskData(taskIcon: "package", taskName: "Get Packages"),
    TaskData(taskIcon: "bills", taskName: "Pay Bills"),
    TaskData(taskIcon: "car", taskName: "Wash Car"),
    TaskData(taskIcon: "drinks", taskName: "Get Drinks"),
]

let hardcodedFullTaskData: [TaskData] = [
    TaskData(taskIcon: "dishe", taskName: "Wash Dishes", taskCategory: "housework"),
    TaskData(taskIcon: "oven", taskName: "Clean Kitchen", taskCategory: "housework"),
    TaskData(taskIcon: "dining", taskName: "Wipe Table", taskCategory: "housework"),
    TaskData(taskIcon: "trash", taskName: "Take out Trash", taskCategory: "housework"),
    TaskData(taskIcon: "dust", taskName: "Sweep Floor", taskCategory: "housework"),
    TaskData(taskIcon: "living room", taskName: "Clean Sofa", taskCategory: "housework"),
    TaskData(taskIcon: "mirror", taskName: "Clean Mirror", taskCategory: "housework"),
    TaskData(taskIcon: "window", taskName: "Clean Window", taskCategory: "housework"),
    
    TaskData(taskIcon: "recycle", taskName: "Recycle", taskCategory: "indoor"),
    TaskData(taskIcon: "chef", taskName: "Prep Meals", taskCategory: "indoor"),
    TaskData(taskIcon: "food1", taskName: "Prep Meals", taskCategory: "indoor"),
    TaskData(taskIcon: "food2", taskName: "Prep Meals", taskCategory: "indoor"),
    TaskData(taskIcon: "fridge", taskName: "Clean Fridge", taskCategory: "indoor"),
    TaskData(taskIcon: "toilet", taskName: "Scrub Toilet", taskCategory: "indoor"),
    TaskData(taskIcon: "laundry", taskName: "Do Laundry", taskCategory: "indoor"),
    TaskData(taskIcon: "tub", taskName: "Clean Shower", taskCategory: "indoor"),
    TaskData(taskIcon: "door", taskName: "Clean Door", taskCategory: "indoor"),
    TaskData(taskIcon: "dog", taskName: "Walk Dog", taskCategory: "indoor"),
    TaskData(taskIcon: "cat", taskName: "Walk Cat", taskCategory: "indoor"),
    
    TaskData(taskIcon: "plants", taskName: "Water Plants", taskCategory: "outdoor"),
    TaskData(taskIcon: "plants2", taskName: "Water Plants", taskCategory: "outdoor"),
    TaskData(taskIcon: "shopping", taskName: "Get Groceries", taskCategory: "outdoor"),
    TaskData(taskIcon: "package", taskName: "Get Packages", taskCategory: "outdoor"),
    TaskData(taskIcon: "bills", taskName: "Pay Bills", taskCategory: "outdoor"),
    TaskData(taskIcon: "bills2", taskName: "Pay Bills", taskCategory: "outdoor"),
    TaskData(taskIcon: "car", taskName: "Wash Car", taskCategory: "outdoor"),
    TaskData(taskIcon: "car 1", taskName: "Wash Car", taskCategory: "outdoor"),
    TaskData(taskIcon: "drinks", taskName: "Get Drinks", taskCategory: "outdoor"),
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
