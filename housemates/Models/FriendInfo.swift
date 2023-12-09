//
//  FriendInfo.swift
//  housemates
//
//  Created by Sean Pham on 12/9/23.
//

import Foundation
import FirebaseFirestoreSwift

struct FriendInfo: Identifiable, Codable {
    
    // MARK: Fields
    @DocumentID var id: String?
    var user_id: String
    var friendsList: [User]
    var friendRequests: [User]
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id
        case user_id
        case friendsList
        case friendRequests
    }
    
}

