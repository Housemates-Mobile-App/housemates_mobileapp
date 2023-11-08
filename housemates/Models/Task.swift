//
//  Task.swift
//  housemates
//
//  Created by Sean Pham on 10/25/23.
//

import Foundation
import FirebaseFirestoreSwift

struct task: Identifiable, Codable {
    
    // MARK: Fields
    @DocumentID var id: String?
    var name: String
    var group_id: String
    var user_id: String?
    var description: String
    var status: String
    var date_started: String?
    var date_completed: String?
    var priority: String
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case group_id
        case user_id
        case status
        case date_started
        case date_completed
        case priority
    }
    
}
