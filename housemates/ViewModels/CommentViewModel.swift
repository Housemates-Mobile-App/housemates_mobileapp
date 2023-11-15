//
//  CommentViewModel.swift
//  housemates
//
//  Created by Sean Pham on 11/15/23.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

class CommentViewModel: ObservableObject {
    private let commentRepository = CommentRepository()
    
    @Published var comments: [Comment] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        commentRepository.$comments
            .receive(on: DispatchQueue.main)
            .sink { updatedComments in
                self.comments = updatedComments
            }
            .store(in: &self.cancellables)
        
    }
}
