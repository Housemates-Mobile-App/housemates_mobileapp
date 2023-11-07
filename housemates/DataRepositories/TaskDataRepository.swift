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
    
    @Published var tasks: [task] = []
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
                
//                print(querySnapshot)
                
                self.tasks = querySnapshot?.documents.compactMap { document in
                    //print(document.data())
                    return try? document.data(as: task.self)
                } ?? []
                
            }
    }
    
    // MARK: CRUD methods
    func create(_ task: task) {
        do {
            let newTask = task
            _ = try store.collection(path).addDocument(from: newTask)
        } catch {
            fatalError("Unable to add Task: \(error.localizedDescription).")
        }
    }
    
    // MARK: Filter methods
//    func getUserTasks(_ user_id: String) -> [task] {
//        return self.tasks.filter { $0.user_id == user_id }
//    }
    
//    func getUserTasks(_ user_id: String) async -> [task] {
//       var tasks = [task]()
//
//       let query = store.collection(path).whereField("user_id", isEqualTo: user_id)
//        do {
//                let querySnapshot = try await query.getDocuments()
//                tasks = querySnapshot.documents.compactMap { document -> task? in
//                    try? document.data(as: task.self)
//                }
//            } catch {
//                print("Error fetching user tasks: \(error)")
//        }
//
//       return tasks
//    }
    func getUserTasks(_ user_id: String) async -> [task] {
        var tasks: [task]
//        print(self.tasks)
        tasks = self.tasks.filter {$0.user_id == user_id}
        return tasks
    }
    
    
    func getGroupTasks(_ group_id: String) async -> [task] {
        var tasks: [task]
        tasks = self.tasks.filter { $0.group_id == group_id }
        return tasks
    }
    
}
