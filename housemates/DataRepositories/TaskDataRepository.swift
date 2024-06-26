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
                
                self.tasks = querySnapshot?.documents.compactMap { document in
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
    
    func delete(_ task: task) {
        guard let taskId = task.id else { return }
        
        store.collection(path).document(taskId).delete { error in
          if let error = error {
            print("Unable to remove Task: \(error.localizedDescription)")
          }
        }
    }
  
    
    func update(_ task: task) {
        guard let taskId = task.id else { return }
        
        do {
          try store.collection(path).document(taskId).setData(from: task)
        } catch {
          fatalError("Unable to update task: \(error.localizedDescription).")
        }
      }
  
}
