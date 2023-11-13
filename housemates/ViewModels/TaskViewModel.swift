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
    
    enum TaskPriority: String, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }
    
    func getTasksForGroup(_ group_id: String) -> [task] {
      return self.tasks.filter { $0.group_id == group_id}
    }

    func getUnclaimedTasksForGroup(_ group_id: String) -> [task] {
        return self.tasks.filter { $0.group_id == group_id && $0.status == .unclaimed}
    }

    func getInProgressTasksForGroup(_ group_id: String) -> [task] {
        return self.tasks.filter { $0.group_id == group_id && $0.status == .inProgress}
    }

    func getCompletedTasksForGroup(_ group_id: String) -> [task] {
        return self.tasks.filter { $0.group_id == group_id && $0.status == .done}
    }
    
    func getCompletedTasksForUser(_ user_id: String) -> [task] {
        return self.tasks.filter { $0.user_id == user_id && $0.status == .done}
    }
    
    func getPendingTasksForUser(_ user_id: String) -> [task] {
        return self.tasks.filter { $0.user_id == user_id && $0.status == .inProgress}
    }
  
    func getNumCompletedTasksForGroup(_ group_id: String) -> Int {
      return self.tasks.filter { $0.group_id == group_id && $0.status == .done}.count
    }

    func isMyTask(task: task, user_id: String) -> Bool {
      return task.user_id == user_id
    }

    func claimTask(task: task, user_id: String) {
        var task = task
        task.user_id = user_id
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        let formattedDate = formatter.string(from: Date())
        task.date_started = formattedDate
        task.date_completed = nil
        task.status = .inProgress
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
    
    func create(task: task) {
        taskRepository.create(task)
    }
    
    func destroy(task: task) {
        taskRepository.delete(task)
    }
    
  }

extension TaskViewModel {
    static func mockTask() -> task {
        return task( name: "Test",
                     group_id: "Test",
                     user_id: "Test",
                     description: "Test",
                     status: .unclaimed,
                     date_started: nil,
                     date_completed: nil,
                     priority: "Test")
    }
    
    static func mock() -> TaskViewModel {
        // Create and return a mock TaskViewModel with a mock task
        let mockTask = task( name: "Test",
                              group_id: "Test",
                              user_id: "Test",
                              description: "Test",
                              status: .unclaimed,
                              date_started: nil,
                              date_completed: nil,
                              priority: "Test")
        
        let mockTaskViewModel = TaskViewModel()
        mockTaskViewModel.tasks = [mockTask]
        return mockTaskViewModel
    }
}
