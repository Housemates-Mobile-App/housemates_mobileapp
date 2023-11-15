//
//  GroupViewModel.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/13/23.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

class PostViewModel: ObservableObject {
    private let postRepository = PostRepository()
    
    @Published var posts: [Post] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        postRepository.$posts
            .receive(on: DispatchQueue.main)
            .sink { updatedPosts in
                self.posts = updatedPosts
            }
            .store(in: &self.cancellables)
        
    }
}
