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
    
    @Published var userTasks: [Task] = []
    @Published var groupTasks: [Task] = []
    
    private var cancellables: Set<AnyCancellable> = []
        
    init() {
        // Subscribe to changes in the TaskRepository's tasks property
        taskRepository.$tasks
            .sink { [weak self] tasks in
                self?.userTasks = tasks // Update tasks for the user
            }
            .store(in: &cancellables)
    }
    
    func tasksForUser(userID: String) {
        userTasks = taskRepository.getTasks(userID: userID)
    }
    
    func tasksForGroup(groupID: String) {
        groupTasks = taskRepository.getTasks(groupID: groupID)
    }
}
