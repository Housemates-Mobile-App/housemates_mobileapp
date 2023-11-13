//
//  TaskData.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/10/23.
//

import Foundation

struct TaskData {
    var taskIcon: String
    var taskName: String
}

let hardcodedHouseworkTaskData: [TaskData] = [
    TaskData(taskIcon: "dalle1", taskName: "Wash Dishes"),
    TaskData(taskIcon: "dalle2", taskName: "Clean Stove"),
    TaskData(taskIcon: "dalle3", taskName: "Wipe Counter"),
    TaskData(taskIcon: "dalle4", taskName: "Take out Trash"),
    TaskData(taskIcon: "dalle5", taskName: "Sweep Floor"),
    TaskData(taskIcon: "dalle6", taskName: "Vacuum Ground"),
]

let hardcodedIndoorTaskData: [TaskData] = [
    TaskData(taskIcon: "dalle1", taskName: "Mop Floor"),
    TaskData(taskIcon: "dalle2", taskName: "Dust Chairs"),
    TaskData(taskIcon: "dalle3", taskName: "Clean Windows"),
    TaskData(taskIcon: "dalle4", taskName: "Scrub Toilet"),
    TaskData(taskIcon: "dalle5", taskName: "Restock Paper"),
    TaskData(taskIcon: "dalle6", taskName: "Clean Shower"),
]

let hardcodedOutdoorTaskData: [TaskData] = [
    TaskData(taskIcon: "dalle1", taskName: "Do Laundry"),
    TaskData(taskIcon: "dalle2", taskName: "Get Groceries"),
    TaskData(taskIcon: "dalle3", taskName: "Prep Meals"),
    TaskData(taskIcon: "dalle4", taskName: "Pay Bills"),
    TaskData(taskIcon: "dalle5", taskName: "Mop Floor"),
    TaskData(taskIcon: "dalle6", taskName: "Dust Chairs"),
]
