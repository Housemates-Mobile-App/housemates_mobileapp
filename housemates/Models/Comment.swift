//
//  Comment.swift
//  housemates
//
//  Created by Sean Pham on 10/31/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Comment: Codable {
    
    // MARK: Fields
    var text: Int
    var date_created: Date
    var user_id: String
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case text
        case date_created
        case user_id
    }
    
}
