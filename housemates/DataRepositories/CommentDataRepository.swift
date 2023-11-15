//
//  CommentDataRepository.swift
//  housemates
//
//  Created by Sean Pham on 11/15/23.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class CommentRepository: ObservableObject {
    private let path: String = "comments"
    private let store = Firestore.firestore()
    
    @Published var comments: [Comment] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.get()
    }
    
    func get() {
        store.collection(path)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting comments: \(error.localizedDescription)")
                    return
                }
                
                self.comments = querySnapshot?.documents.compactMap { document in
                    return try? document.data(as: Comment.self)
                } ?? []
                
            }
    }
    
    // MARK: CRUD methods
    func create(_ comment: Comment) {
        do {
            let newComment = comment
            _ = try store.collection(path).addDocument(from: newComment)
        } catch {
            fatalError("Unable to add comment: \(error.localizedDescription).")
        }
    }
    
    func delete(_ comment: Comment) {
        guard let commentId = comment.id else { return }
        
        store.collection(path).document(commentId).delete { error in
          if let error = error {
            print("Unable to remove comment: \(error.localizedDescription)")
          }
        }
    }
  
    func update(_ comment: Comment) {
        guard let commentId = comment.id else { return }
        
        do {
          try store.collection(path).document(commentId).setData(from: comment)
        } catch {
          fatalError("Unable to update comment: \(error.localizedDescription).")
        }
      }
}
