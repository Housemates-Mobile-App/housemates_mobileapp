//
//  UserDataRepository.swift
//  housemates
//
//  Created by Sean Pham on 10/31/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserRepository: ObservableObject {
    private let path: String = "users"
    private let store = Firestore.firestore()
    
    @Published var users: [User] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.get()
    }
    
    func get() {
        store.collection(path)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting users: \(error.localizedDescription)")
                    return
                }
                
                self.users = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: User.self)
                } ?? []
                
            }
    }
    
//    func getUserByID(_ id: String) async -> User {
//        guard let snapshot = try? await store.collection(path).document(id).getDocument() else { return }
//        let user = try? snapshot.data(as: User.self)
//    }
    
    // MARK: CRUD methods
    func create(_ user: User) {
        do {
            let newUser = user
            _ = try store.collection(path).addDocument(from: newUser)
        } catch {
            fatalError("Unable to add User: \(error.localizedDescription).")
        }
    }
    
    func updateUser(_ user: User, fields: [String: Any]) {
         guard let userId = user.id else {
             fatalError("User ID is nil. Cannot update user without ID.")
         }

         do {
             _ = try store.collection(path).document(userId).setData(fields, merge: true)
         } catch {
             fatalError("Unable to update User: \(error.localizedDescription).")
         }
    }
    
    // MARK: Filter methods
    
    
}
