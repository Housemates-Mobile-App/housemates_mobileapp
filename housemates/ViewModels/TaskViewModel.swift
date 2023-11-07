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
    
    @Published var userTasks: [task] = []
    @Published var groupTasks: [task] = []
    
    private var cancellables: Set<AnyCancellable> = []
        
    init() {
        // Subscribe to changes in the TaskRepository's tasks property
        taskRepository.$tasks
            .sink { [weak self] tasks in
                self?.userTasks = tasks // Update tasks for the user
            }
            .store(in: &cancellables)
    }

    func fetchUserTasks(_ userId: String) async {
        self.userTasks = await taskRepository.getUserTasks(userId)
    }

    
    func fetchGroupTasks(_ groupId: String) async {
        self.groupTasks = await taskRepository.getGroupTasks(groupId)
    }
}
