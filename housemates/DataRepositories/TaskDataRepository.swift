//
//  TaskDataRepository.swift
//  housemates
//
//  Created by Sanmoy Karmakar on 11/2/23.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class TaskRepository: ObservableObject {
    private let path: String = "tasks"
    private let store = Firestore.firestore()
    
    @Published var tasks: [Task] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.get()
    }
    
    func get() {
        store.collection(path)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting tasks: \(error.localizedDescription)")
                    return
                }
                
                self.tasks = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Task.self)
                } ?? []
                
            }
    }
    
    // MARK: CRUD methods
    func create(_ task: Task) {
        do {
            let newTask = task
            _ = try store.collection(path).addDocument(from: newTask)
        } catch {
            fatalError("Unable to add Task: \(error.localizedDescription).")
        }
    }
    
    // MARK: Filter methods
    func getTasks(userID user_id: String) -> [Task] {
            return tasks.filter { $0.user_id == user_id }
    }
        
    func getTasks(groupID group_id: String) -> [Task] {
            return tasks.filter { $0.group_id == group_id }
    }
    
}
