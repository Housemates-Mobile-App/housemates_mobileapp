//
//  TaskViewModel.swift
//  housemates
//
//  Created by Sanmoy Karmakar on 11/3/23.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import SwiftUI


class TaskViewModel: ObservableObject {
    private let taskRepository = TaskRepository()
    
    @Published var tasks: [task] = []
    private var cancellables: Set<AnyCancellable> = []

    init() {
        taskRepository.$tasks
            .receive(on: DispatchQueue.main)
            .sink { updatedTasks in
                self.tasks = updatedTasks
            }
            .store(in: &self.cancellables)
    }
    
    func getUserIdByTaskId(_ tid: String) -> String? {
        let associatedTask = self.tasks.filter { $0.id == tid }.first
        return associatedTask?.user_id
    }
    
    func getTasksForGroup(_ group_id: String) -> [task] {
      return self.tasks.filter { $0.group_id == group_id}
    }

    func getUnclaimedTasksForGroup(_ group_id: String?) -> [task] {
        guard let groupId = group_id else {
            return []
        }

        return self.tasks.filter { $0.group_id == groupId && $0.status == .unclaimed }
    }

    func getInProgressTasksForGroup(_ group_id: String?) -> [task] {
        guard let groupId = group_id else {
            return []
        }

        return self.tasks.filter { $0.group_id == groupId && $0.status == .inProgress }
    }

    func getCompletedTasksForGroup(_ group_id: String?) -> [task] {
        guard let groupId = group_id else {
            return []
        }

        return self.tasks.filter { $0.group_id == groupId && $0.status == .done }
    }
    
    func getCompletedTasksForUser(_ user_id: String) -> [task] {
        return self.tasks.filter { $0.user_id == user_id && $0.status == .done}
    }
    
    func getPendingTasksForUser(_ user_id: String) -> [task] {
        return self.tasks.filter { $0.user_id == user_id && $0.status == .inProgress}
    }
    
    func getRecentCompletedTasksForUser(_ user_id: String) -> [task] {
        let completedTasks = getCompletedTasksForUser(user_id)
        
        let currentDate = Date()
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: currentDate)!
        let eightDaysAgo = calendar.date(byAdding: .day, value: -8, to: currentDate)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yy h:mm a"
//        let formattedDate = formatter.string(from: Date())
        
        let completedFilteredTasks = completedTasks.filter {
            task in {
                guard let completionDate = task.date_completed else { return false }
                
                return dateFormatter.date(from: completionDate) ?? eightDaysAgo >= sevenDaysAgo
            }()
        }
        
        return completedFilteredTasks
        
    }
    
    
    // Function to unclaim tasks for a user who leaves a group
    func unclaimTasksForUserLeavingGroup(uid: String) {
        tasks
            .filter { $0.user_id == uid && $0.status == .inProgress }
            .forEach { task in
                var updatedTask = task
                updatedTask.user_id = nil
                updatedTask.status = .unclaimed
                taskRepository.update(updatedTask)
            }
    }
  
    func getNumPendingTasksForUser(_ user_id: String) -> Int {
      return self.tasks.filter { $0.user_id == user_id && $0.status == .inProgress}.count
    }
  
    func getNumCompletedTasksForUser(_ user_id: String) -> Int {
      return self.tasks.filter { $0.user_id == user_id && $0.status == .done}.count
    }
  
    func getNumCompletedTasksForGroup(_ group_id: String) -> Int {
      return self.tasks.filter { $0.group_id == group_id && $0.status == .done}.count
    }

    func isMyTask(task: task, user_id: String) -> Bool {
      return task.user_id == user_id
    }

    func claimTask(task: task, user_id: String) { //, image: UIImage?) async {
//        guard let imageURL = await getPostPicURL(image: image) else {
//            print("Failed to upload image or get URL")
//            return
//        }
//        
//        var imageURL: String?
//        if let image = image {
//            imageURL = await getPostPicURL(image: image)
//            guard imageURL != nil else {
//                print("Failed to upload image or get URL")
//                return
//            }
//        }
        
        var task = task
        task.user_id = user_id
//        task.beforeImageURL = imageURL
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        let formattedDate = formatter.string(from: Date())
        task.date_started = formattedDate
        task.date_completed = nil
        task.status = .inProgress
        taskRepository.update(task)
    }
  
  func undoTask(task: task, user_id: String) {
//        guard let imageURL = await getPostPicURL(image: image) else {
//            print("Failed to upload image or get URL")
//            return
//        }
//
      
      var task = task
      task.user_id = nil
      task.beforeImageURL = nil
      task.date_started = nil
      task.date_completed = nil
      
      task.status = .unclaimed
      taskRepository.update(task)
  }
  
    
    
    
    func completeTask(task: task) {
        var task = task
        task.date_started = nil
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        let formattedDate = formatter.string(from: Date())
        task.date_completed = formattedDate
        task.status = .done
        taskRepository.update(task)
      }
  
  func getTimestamp(time: String) -> String? {
      let formatter = DateFormatter()
      formatter.dateFormat = "MM.dd.yy h:mm a"
      formatter.locale = Locale(identifier: "en_US_POSIX")
      guard let completeDate = formatter.date(from: time) else {
          return nil
      }

      let now = Date()
      let calendar = Calendar.current

      let hourDifference = calendar.dateComponents([.hour], from: completeDate, to: now).hour ?? 0
      let minuteDifference = calendar.dateComponents([.minute], from: completeDate, to: now).minute ?? 0
    
      if calendar.isDateInToday(completeDate) || hourDifference < 24 {
          if hourDifference == 0 {
              return minuteDifference == 0 ? "<1m" : "\(minuteDifference)m"
          } else {
              return "\(hourDifference)h"
          }
      } else {
          
          let dayDifference = calendar.dateComponents([.day], from: completeDate, to: now).day ?? 0
          return "\(dayDifference)d"
      }
  }
  
  func getCompletedTasksForUserByDay(_ user_id: String, timeframe: String) -> [task] {
       let completedTasks = getCompletedTasksForUser(user_id)

       let currentDate = Date()
       let calendar = Calendar.current

       var startDate: Date

       switch timeframe {
       case "Today":
           startDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
       case "Last Week":
           startDate = calendar.date(byAdding: .day, value: -7, to: currentDate)!
       case "Last Month":
           startDate = calendar.date(byAdding: .month, value: -1, to: currentDate)!
       default:
         return completedTasks

       }

       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "MM.dd.yy h:mm a"

       let completedFilteredTasks = completedTasks.filter {
           guard let completionDateStr = $0.date_completed,
                 let completionDate = dateFormatter.date(from: completionDateStr) else {
               return false
           }

           return completionDate >= startDate
       }

     return completedFilteredTasks
   }

   func getCompletedTasksForGroupByDay(_ group_id: String, timeframe: String) -> [task] {
       let completedTasks = getCompletedTasksForGroup(group_id)

       let currentDate = Date()
       let calendar = Calendar.current

       var startDate: Date

       switch timeframe {
       case "Today":
           startDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
       case "Last Week":
           startDate = calendar.date(byAdding: .day, value: -7, to: currentDate)!
       case "Last Month":
           startDate = calendar.date(byAdding: .month, value: -1, to: currentDate)!
       default:
         return completedTasks

       }

       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "MM.dd.yy h:mm a"

       let completedFilteredTasks = completedTasks.filter {
           guard let completionDateStr = $0.date_completed,
                 let completionDate = dateFormatter.date(from: completionDateStr) else {
               return false
           }

           return completionDate >= startDate
       }

     return completedFilteredTasks
   }
  
  
    func editTask(task: task, name: String? = nil, description: String? = nil, priority: String? = nil, icon: String? = nil, status: task.Status? = nil, recurrence: Recurrence? = nil, recurrenceStartDate: Date? = nil, recurrenceEndDate: Date? = nil) {
        
        var taskToUpdate = task

        // Only update the fields that are not nil
        if let name = name {
            taskToUpdate.name = name
        }
        if let description = description {
            taskToUpdate.description = description
        }
        if let priority = priority {
            taskToUpdate.priority = priority
        }
        if let icon = icon {
            taskToUpdate.icon = icon
        }
        if let status = status {
            taskToUpdate.status = status
        }
        if let recurrence = recurrence {
            taskToUpdate.recurrence = recurrence
        }
        if let recurrenceStartDate = recurrenceStartDate {
            taskToUpdate.recurrenceStartDate = recurrenceStartDate
        }
        if let recurrenceEndDate = recurrenceEndDate {
            taskToUpdate.recurrenceEndDate = recurrenceEndDate
        }

        taskRepository.update(taskToUpdate)
    }
    
    func create(task: task) {
        taskRepository.create(task)
    }
    
    func destroy(task: task) {
        taskRepository.delete(task)
    }
    
    var timerCancellable: AnyCancellable?
            
    func startTaskResetTimer() {
        timerCancellable = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                self?.resetRecurringTasks()
            }
    }
    
    private func resetRecurringTasks() {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        let formattedDate = formatter.string(from: Date())
        for var task in tasks where task.recurrence != .none {
            guard let startDate = task.recurrenceStartDate, let endDate = task.recurrenceEndDate,
                  startDate <= currentDate, endDate >= currentDate else { continue }
            
            if taskNeedsReset(task: task, currentDate: currentDate) {
                task.status = .unclaimed
                task.user_id = nil
                task.date_created = formattedDate
                task.date_started = nil
                task.date_completed = nil
                taskRepository.update(task)
            }
        }
    }
    
    private func taskNeedsReset(task: task, currentDate: Date) -> Bool {
        guard let completionDate = task.date_completed, let startDate = task.recurrenceStartDate else {
            return false
        }
        
        var nextResetDate: Date?
        let calendar = Calendar.current
        
        switch task.recurrence {
        case .daily:
            nextResetDate = calendar.date(byAdding: .day, value: 1, to: startDate)
        case .weekly:
            nextResetDate = calendar.date(byAdding: .weekOfYear, value: 1, to: startDate)
        case .monthly:
            nextResetDate = calendar.date(byAdding: .month, value: 1, to: startDate)
        default:
            break
        }
        
        if let nextResetDate = nextResetDate, nextResetDate <= currentDate {
            return true
        }
        
        return false
    }
    
    // Call this method when the app starts or when the view appears
    func setupRecurringTaskReset() {
        startTaskResetTimer()
    }
    
    // Cancel the timer when TaskViewModel deinitializes
    deinit {
        timerCancellable?.cancel()
    }

  }

extension TaskViewModel {
    static func mockTask() -> task {
        return task( name: "test name",
                     group_id: "Test",
                     user_id: "Test",
                     description: "test description",
                     status: .unclaimed,
                     date_created: nil,
                     date_started: nil,
                     date_completed: nil,
                     priority: "test priority",
                     recurrence: .none)
    }
    
    static func mock() -> TaskViewModel {
        // Create and return a mock TaskViewModel with a mock task
        let mockTask = task( name: "Test",
                              group_id: "Test",
                              user_id: "Test",
                              description: "Test",
                              status: .unclaimed,
                              date_created: nil,
                              date_started: nil,
                              date_completed: nil,
                              priority: "Test",
                              recurrence: .none)
        
        let mockTaskViewModel = TaskViewModel()
        mockTaskViewModel.tasks = [mockTask]
        return mockTaskViewModel
    }
}
