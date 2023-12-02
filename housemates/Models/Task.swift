//
//  Task.swift
//  housemates
//
//  Created by Sean Pham on 10/25/23.
//

import Foundation
import FirebaseFirestoreSwift

enum Recurrence: String, Codable {
    case none = "Does Not Repeat"
    case daily = "Every Day"
    case weekly = "Every Week"
    case monthly = "Every Month"
}

struct task: Identifiable, Codable {
    
    // MARK: Fields
    @DocumentID var id: String?
    var name: String
    var group_id: String
    var user_id: String?
    var description: String
    var status: Status
    var date_created: String?
    var date_started: String?
    var date_completed: String?
    var priority: String
    var icon: String?
    var recurrence: Recurrence
    var recurrenceStartDate: Date?
    var recurrenceEndDate: Date?

    var beforeImageURL: String?
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case group_id
        case user_id
        case status
        case date_created
        case date_started
        case date_completed
        case priority
        case icon
        case recurrence
        case recurrenceStartDate
        case recurrenceEndDate
        
        case beforeImageURL

    }
    
    enum Status: String, Codable {
        case inProgress
        case unclaimed
        case done
    }
    
}
