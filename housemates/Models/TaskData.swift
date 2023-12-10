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
    TaskData(taskIcon: "brita", taskName: "Refill Water"),
]

let hardcodedIndoorTaskData: [TaskData] = [
    TaskData(taskIcon: "recycle", taskName: "Recycle"),
    TaskData(taskIcon: "chef", taskName: "Prep Meals"),
    TaskData(taskIcon: "fridge", taskName: "Clear Fridge"),
    TaskData(taskIcon: "toilet", taskName: "Scrub Toilet"),
    TaskData(taskIcon: "laundry", taskName: "Do Laundry"),
    TaskData(taskIcon: "tub", taskName: "Clean Shower"),
]

let hardcodedOutdoorTaskData: [TaskData] = [
    TaskData(taskIcon: "plants", taskName: "Water Plants"),
    TaskData(taskIcon: "shopping", taskName: "Get Groceries"),
    TaskData(taskIcon: "package", taskName: "Get Packages"),
    TaskData(taskIcon: "shovel snow", taskName: "Shovel Snow"),
    TaskData(taskIcon: "car", taskName: "Wash Car"),
    TaskData(taskIcon: "drinks", taskName: "Get Drinks"),
]

let hardcodedFullTaskData: [TaskData] = [
    TaskData(taskIcon: "dishe", taskName: "Wash Dishes", taskCategory: "Housework"),
    TaskData(taskIcon: "oven", taskName: "Clean Kitchen", taskCategory: "Housework"),
    TaskData(taskIcon: "dining", taskName: "Wipe Table", taskCategory: "Housework"),
    TaskData(taskIcon: "trash", taskName: "Take Out Trash", taskCategory: "Housework"),
    TaskData(taskIcon: "dust", taskName: "Sweep Floor", taskCategory: "Housework"),
    TaskData(taskIcon: "living room", taskName: "Clean Sofa", taskCategory: "Housework"),
    TaskData(taskIcon: "mirror", taskName: "Clean Mirror", taskCategory: "Housework"),
    TaskData(taskIcon: "window", taskName: "Clean Window", taskCategory: "Housework"),
    TaskData(taskIcon: "TV", taskName: "TV", taskCategory: "Housework"),
    TaskData(taskIcon: "closet", taskName: "closet", taskCategory: "Housework"),
    
    TaskData(taskIcon: "recycle", taskName: "Recycle", taskCategory: "Indoor"),
    TaskData(taskIcon: "chef", taskName: "Prep Meals", taskCategory: "Indoor"),
    TaskData(taskIcon: "food2", taskName: "Prep Meals", taskCategory: "Indoor"),
    TaskData(taskIcon: "fridge", taskName: "Clean Fridge", taskCategory: "Indoor"),
    TaskData(taskIcon: "toilet", taskName: "Scrub Toilet", taskCategory: "Indoor"),
    TaskData(taskIcon: "laundry", taskName: "Do Laundry", taskCategory: "Indoor"),
    TaskData(taskIcon: "tub", taskName: "Clean Shower", taskCategory: "Indoor"),
    TaskData(taskIcon: "door", taskName: "Clean Door", taskCategory: "Indoor"),
    TaskData(taskIcon: "party", taskName: "Clean Shower", taskCategory: "Indoor"),
    TaskData(taskIcon: "cosmetic", taskName: "Clean Door", taskCategory: "Indoor"),
    
    
    TaskData(taskIcon: "plants", taskName: "Water Plants", taskCategory: "Outdoor"),
    TaskData(taskIcon: "plants2", taskName: "Water Plants", taskCategory: "Outdoor"),
    TaskData(taskIcon: "shopping", taskName: "Get Groceries", taskCategory: "Outdoor"),
    TaskData(taskIcon: "package", taskName: "Get Packages", taskCategory: "Outdoor"),
    TaskData(taskIcon: "jacket", taskName: "Pay Bills", taskCategory: "Outdoor"),
    TaskData(taskIcon: "bills2", taskName: "Pay Bills", taskCategory: "Outdoor"),
    TaskData(taskIcon: "car", taskName: "Wash Car", taskCategory: "Outdoor"),
    TaskData(taskIcon: "bus", taskName: "Wash Car", taskCategory: "Outdoor"),
    TaskData(taskIcon: "drinks", taskName: "Get Drinks", taskCategory: "Outdoor"),
    TaskData(taskIcon: "grill", taskName: "Get Drinks", taskCategory: "Outdoor"),
    
    TaskData(taskIcon: "eggs", taskName: "Water Plants", taskCategory: "Food"),
    TaskData(taskIcon: "spaghetti", taskName: "Water Plants", taskCategory: "Food"),
    TaskData(taskIcon: "fries", taskName: "Get Groceries", taskCategory: "Food"),
    TaskData(taskIcon: "bao", taskName: "Get Packages", taskCategory: "Food"),
    TaskData(taskIcon: "sushi", taskName: "Pay Bills", taskCategory: "Food"),
    TaskData(taskIcon: "orange", taskName: "Pay Bills", taskCategory: "Food"),
    TaskData(taskIcon: "peach", taskName: "Wash Car", taskCategory: "Food"),
    TaskData(taskIcon: "strawberry", taskName: "Wash Car", taskCategory: "Food"),
    TaskData(taskIcon: "eggplant", taskName: "Get Drinks", taskCategory: "Food"),
    TaskData(taskIcon: "food1", taskName: "Prep Meals", taskCategory: "Food"),
    
    TaskData(taskIcon: "dog", taskName: "Walk Dog", taskCategory: "Pets"),
    TaskData(taskIcon: "cat", taskName: "Walk Cat", taskCategory: "Pets"),
    TaskData(taskIcon: "cow", taskName: "Water Plants", taskCategory: "Pets"),
    TaskData(taskIcon: "lamb", taskName: "Water Plants", taskCategory: "Pets"),
    TaskData(taskIcon: "mouse", taskName: "Get Groceries", taskCategory: "Pets"),
    TaskData(taskIcon: "panda", taskName: "Get Packages", taskCategory: "Pets"),
    TaskData(taskIcon: "penguin", taskName: "Penguin", taskCategory: "Pets"),
    TaskData(taskIcon: "koala", taskName: "Get Groceries", taskCategory: "Pets"),
    TaskData(taskIcon: "frog", taskName: "Get Packages", taskCategory: "Pets"),
    TaskData(taskIcon: "rabbit", taskName: "Penguin", taskCategory: "Pets"),
    
    
    TaskData(taskIcon: "bike", taskName: "Water Plants", taskCategory: "Errands"),
    TaskData(taskIcon: "mail", taskName: "Water Plants", taskCategory: "Errands"),
    TaskData(taskIcon: "buy", taskName: "Get Groceries", taskCategory: "Errands"),
    TaskData(taskIcon: "gas", taskName: "Get Packages", taskCategory: "Errands"),
    TaskData(taskIcon: "bills", taskName: "Pay Bills", taskCategory: "Errands"),
    
    TaskData(taskIcon: "math", taskName: "Water Plants", taskCategory: "School"),
    TaskData(taskIcon: "art", taskName: "Water Plants", taskCategory: "School"),
    TaskData(taskIcon: "english", taskName: "Get Groceries", taskCategory: "School"),
    TaskData(taskIcon: "science", taskName: "Get Packages", taskCategory: "School"),
    TaskData(taskIcon: "geometry", taskName: "Pay Bills", taskCategory: "School"),
    
    TaskData(taskIcon: "basketball", taskName: "Water Plants", taskCategory: "Active"),
    TaskData(taskIcon: "soccer", taskName: "Water Plants", taskCategory: "Active"),
    TaskData(taskIcon: "football", taskName: "Get Groceries", taskCategory: "Active"),
    TaskData(taskIcon: "badminton", taskName: "Get Packages", taskCategory: "Active"),
    TaskData(taskIcon: "muscle", taskName: "Pay Bills", taskCategory: "Active"),
    
    TaskData(taskIcon: "bowling", taskName: "Water Plants", taskCategory: "Entertainment"),
    TaskData(taskIcon: "poker", taskName: "Water Plants", taskCategory: "Entertainment"),
    TaskData(taskIcon: "8ball", taskName: "Get Groceries", taskCategory: "Entertainment"),
    TaskData(taskIcon: "disco", taskName: "Get Packages", taskCategory: "Entertainment"),
    TaskData(taskIcon: "beer", taskName: "Pay Bills", taskCategory: "Entertainment"),
    TaskData(taskIcon: "karaoke", taskName: "Water Plants", taskCategory: "Entertainment"),
    TaskData(taskIcon: "dominos", taskName: "Water Plants", taskCategory: "Entertainment"),
    TaskData(taskIcon: "chess", taskName: "Get Groceries", taskCategory: "Entertainment"),
    TaskData(taskIcon: "games", taskName: "Get Packages", taskCategory: "Entertainment"),
    TaskData(taskIcon: "dice", taskName: "Pay Bills", taskCategory: "Entertainment"),
    
    
    TaskData(taskIcon: "santa", taskName: "Water Plants", taskCategory: "Miscellaneous"),
    TaskData(taskIcon: "pumpkin", taskName: "Water Plants", taskCategory: "Miscellaneous"),
    TaskData(taskIcon: "tooth", taskName: "Get Groceries", taskCategory: "Miscellaneous"),
    TaskData(taskIcon: "polygon", taskName: "Get Packages", taskCategory: "Miscellaneous"),
    TaskData(taskIcon: "coffee", taskName: "Pay Bills", taskCategory: "Miscellaneous"),
  
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
