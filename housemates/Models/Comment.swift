//
//  Comment.swift
//  housemates
//
//  Created by Sean Pham on 10/31/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Comment: Identifiable, Codable {
    
    // MARK: Fields'
    var id = UUID()
    var text: String
    var date_created: String
    var created_by: User
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case date_created
        case created_by
    }
    
}
