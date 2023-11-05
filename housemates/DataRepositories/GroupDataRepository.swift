//
//  GroupDataRepository.swift
//  housemates
//
//  Created by Sean Pham on 10/25/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class GroupRepository: ObservableObject {
    private let path: String = "groups"
    private let store = Firestore.firestore()

    @Published var groups: [Group] = []
    private var cancellables: Set<AnyCancellable> = []

    init() {
        self.get()
    }

    func get() {
        store.collection(path)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting groups: \(error.localizedDescription)")
                    return
                }
                
                self.groups = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Group.self)
                } ?? []
                
         }
    }

    func getGroupIdByCode(_ group_code: String) async -> String? {
       var groupId: String?

       let query = store.collection(path).whereField("group_code", isEqualTo: group_code)
        let querySnapshot = try? await query.getDocuments()

       if let document = querySnapshot?.documents.first {
           // Extract the group_id from the document
           groupId = document.documentID
       }

       return groupId
    }
    
    // MARK: CRUD methods
    

    // MARK: Filtering methods
}
