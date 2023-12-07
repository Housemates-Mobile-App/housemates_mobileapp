//
//  Reactions.swift
//  housemates
//
//  Created by Sean Pham on 12/6/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Reaction: Identifiable, Codable {
    
    // MARK: Fields
    var id = UUID()
    var emoji: String
    var created_by: User
    var date_created: Date
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case emoji
        case created_by
        case date_created
    }
    
}
