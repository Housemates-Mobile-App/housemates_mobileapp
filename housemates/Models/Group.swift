//
//  Group.swift
//  housemates
//
//  Created by Sean Pham on 10/25/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Group: Identifiable, Codable {
    
    // MARK: Fields
    @DocumentID var id: String?
    var address: String
    var name: String
    var code: Int
    var users: [User]
    var tasks: [Task]
    var amentities: [Amentity]
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case address
        case name = "group_name"
        case code = "group_code"
        case users
        case tasks
        case amentities
    }
}
