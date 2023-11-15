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
    var task_id: String
    var group_id: String
    var user_id: String
    var num_likes: Int
    var num_comments: Int
    var liked_by: [String]
    var comments: [Comment]
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case task_id
        case group_id
        case user_id
        case num_likes
        case num_comments
        case liked_by
        case comments
    }
    
}
