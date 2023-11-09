//
//  UserViewModel.swift
//  housemates
//
//  Created by Sean Pham on 11/8/23.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

class UserViewModel: ObservableObject {
    private let userRepository = UserRepository()
    private let groupRepository = GroupRepository()

    @Published var users: [User] = []
    private var cancellables: Set<AnyCancellable> = []
        
    init() {
        userRepository.$users
            .receive(on: DispatchQueue.main)
            .sink { updatedUsers in
                self.users = updatedUsers
                print("UPDATED USERS: \(updatedUsers)")
            }
            .store(in: &self.cancellables)
        
    }
    
    
    func getUserByID(_ uid: String) -> User? {
        let filteredUsers = self.users.filter { $0.id == uid }
        return filteredUsers.first
    }
    
    func joinGroup(group_code: String, uid: String) -> User? {
            // Fetch the group ID for the given group code
            guard let group_id = groupRepository.getGroupIdByCode(group_code) else {
                print("Failed to get group ID for code: \(group_code)")
                return nil
            }
        
            // Fetch the user object by ID
            guard var user = getUserByID(uid) else {
                print("Failed to get User with ID: \(uid)")
                return nil
            }
        
            // Update the group_id for the current user
            user.group_id = group_id
            userRepository.update(user)
        
            return user
    }
        
    func createAndJoinGroup(group_name: String, address: String, uid: String) {
        let group_code = String(Int.random(in: 1000...9999))
        let group_id = UUID().uuidString
        let group = Group(id: group_id, address: address, name: group_name, code: group_code)
        groupRepository.create(group)
        joinGroup(group_code: group_code, uid: uid)
   

    }
}

