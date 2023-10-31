//
//  Task.swift
//  housemates
//
//  Created by Sean Pham on 10/25/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Task: Identifiable, Codable {
    
    // MARK: Fields
    var id: Int
    var name: String
    var description: String
    var in_progress: Bool
    var completed: Bool
    var in_progress_by: User?
    var completed_by: User?
    var date_completed: Date?
    var priority: String
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case name = "task_name"
        case description
        case in_progress
        case completed
        case in_progress_by
        case completed_by
        case date_completed
        case priority
    }
    
}
