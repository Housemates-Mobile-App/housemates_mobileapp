//
//  amentity.swift
//  housemates
//
//  Created by Sean Pham on 10/25/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Amentity: Identifiable, Codable {
    
    // MARK: Fields
    var id: Int
    var name: String
    var in_use: Bool
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case in_use
    }
    
}
