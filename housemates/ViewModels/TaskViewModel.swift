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

    func isMyTask(task: task, user_id: String) -> Bool {
      return task.user_id == user_id
    }

    func claimTask(task: task, user_id: String) {
        var task = task
        task.user_id = user_id
        task.date_started = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
        task.date_completed = nil
        task.status = .inProgress
        taskRepository.update(task)
    }
    
    func completeTask(task: task) {
        var task = task
        task.date_started = nil
        task.date_completed = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
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
        // Create and return a mock AuthViewModel with a mock user
        return task( name: "Test",
                     group_id: "Test",
                     user_id: "Test",
                     description: "Test",
                     status: .unclaimed,
                     date_started: nil,
                     date_completed: nil,
                     priority: "Test")
    }
}
