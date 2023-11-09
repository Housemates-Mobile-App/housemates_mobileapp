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
        return self.tasks.filter { $0.group_id == group_id && $0.status == "unclaimed"}
    }


    func getInProgressTasksForGroup(_ group_id: String) -> [task] {
      return self.tasks.filter { $0.group_id == group_id && $0.status == "inProgress"}
    }

    func getCompletedTasksForGroup(_ group_id: String) -> [task] {
      return self.tasks.filter { $0.group_id == group_id && $0.status == "done"}
    }

    func isMyTask(task: task, user_id: String) -> Bool {
      return task.user_id == user_id
    }

    func claimTask(task: task, date_started: String) {
      taskRepository.update(task, status: "inProgress", date_started: date_started, date_completed: nil)
    }
    
    func completeTask(task: task, date_completed: String) {
      taskRepository.update(task, status: "done", date_started: nil, date_completed: date_completed)
      }
    
    func create(task: task) {
        taskRepository.create(task)
    }
    
    func destroy(task: task) {
        taskRepository.delete(task)
    }
    
  }
