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
    var group_id: String
    var created_by: User
    var num_likes: Int
    var num_comments: Int
    var liked_by: [String]
    var comments: [Comment]
    var imageURLString: String?
    var caption: String?
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case task
        case group_id
        case created_by
        case num_likes
        case num_comments
        case liked_by
        case comments
        case imageURLString
        case caption
    }
    
}
