//
//  Post.swift
//  housemates
//
//  Created by Sean Pham on 10/25/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable {
    
    // MARK: Fields
    @DocumentID var id: String?
    var task: task
    var num_likes: Int
    var num_comments: Int
    var liked_by: [User]?
    var comments: [Comment]?
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case task
        case num_likes = "number_likes"
        case num_comments = "number_comments"
        case liked_by
        case comments
    }
    
}
