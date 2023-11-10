//
//  PostRepository.swift
//  housemates
//
//  Created by Sean Pham on 10/25/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class PostRepository: ObservableObject {
    private let path: String = "posts"
    private let store = Firestore.firestore()

    @Published var posts: [Post] = []
    private var cancellables: Set<AnyCancellable> = []

    init() {
        self.get()
    }

    func get() {
        store.collection(path)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting posts: \(error.localizedDescription)")
                    return
                }
                
                self.posts = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Post.self)
                } ?? []
                
            }
    }

    // MARK: CRUD methods

    // MARK: Filtering methods
}
