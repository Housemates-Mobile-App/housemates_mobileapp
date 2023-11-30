//
//  Task.swift
//  housemates
//
//  Created by Sean Pham on 10/25/23.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI

enum Recurrence: String, SliderPickerItem, Codable, CaseIterable {
    case none = "Never"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    
    var displayValue: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .none:
            return .gray
        case .daily:
            return .blue
        case .weekly:
            return .green
        case .monthly:
            return .orange
        }
    }
}

enum TaskPriority: String, SliderPickerItem, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var displayValue: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .low:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .red
        }
    }
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

    }
    
    enum Status: String, Codable {
        case inProgress
        case unclaimed
        case done
    }
    
}
