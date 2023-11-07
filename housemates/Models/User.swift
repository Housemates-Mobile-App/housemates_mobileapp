//
//  User.swift
//  housemates
//
//  Created by Sean Pham on 10/25/23.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    
    // MARK: Fields
    @DocumentID var id: String?
    var first_name: String
    var last_name: String
    var is_home: Bool?
    var phone_number: String
    var email: String
    var birthday: String
    var group_id: String?
    var imageURLString: String?
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case first_name
        case last_name
        case is_home
        case phone_number
        case email
        case birthday
        case group_id
        case imageURLString
    }
}
