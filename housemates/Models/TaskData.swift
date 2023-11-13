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

let hardcodedTaskData: [TaskData] = [
    TaskData(taskIcon: "dish", taskName: "Wash Dishes"),
    TaskData(taskIcon: "stove", taskName: "Clean Stove"),
    TaskData(taskIcon: "wipe", taskName: "Wipe Counter"),
    TaskData(taskIcon: "trash", taskName: "Take out Trash"),
    TaskData(taskIcon: "broom", taskName: "Sweep Floor"),
    TaskData(taskIcon: "vacuum", taskName: "Vacuum Ground"),
    TaskData(taskIcon: "mop", taskName: "Mop Floor"),
    TaskData(taskIcon: "dust", taskName: "Dust Chairs"),
    TaskData(taskIcon: "window", taskName: "Clean Windows"),
    TaskData(taskIcon: "toilet", taskName: "Scrub Toilet"),
    TaskData(taskIcon: "toiletpaper", taskName: "Restock Paper"),
    TaskData(taskIcon: "shower", taskName: "Clean Shower"),
    TaskData(taskIcon: "laundry", taskName: "Do Laundry"),
    TaskData(taskIcon: "shop", taskName: "Get Groceries"),
    TaskData(taskIcon: "eat", taskName: "Prep Meals"),
    TaskData(taskIcon: "bills", taskName: "Pay Bills"),
]
