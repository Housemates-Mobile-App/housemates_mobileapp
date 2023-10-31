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
    var id: Int
    var username: String
    var first_name: String
    var last_name: String
    var is_home: Bool
    var phone_number: Int
    var email: String
    var birthday: Date
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case first_name
        case last_name
        case is_home
        case phone_number
        case email
        case birthday
    }
}
