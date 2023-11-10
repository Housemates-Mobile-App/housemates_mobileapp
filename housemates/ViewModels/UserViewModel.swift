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
            }
            .store(in: &self.cancellables)
        
    }
    
    func getUserByID(_ uid: String) -> User? {
        let filteredUsers = self.users.filter { $0.id == uid }
        return filteredUsers.first
    }
    
    func getUserGroupmates(_ uid: String) -> [User] {
        guard let currentUser = self.users.first(where: { $0.id == uid }), let groupID = currentUser.group_id else {
            return []
        }
        
        return self.users.filter { $0.group_id == groupID && $0.id != uid }
    }
    
    func getUserGroupmatesInclusive(_ uid: String) -> [User] {
         guard let currentUser = self.users.first(where: { $0.id == uid }), let groupID = currentUser.group_id else {
             return []
         }

         var groupmates = self.users.filter { $0.group_id == groupID && $0.id != uid }
         // did this so currentUser would appear at the very end.
         groupmates.append(currentUser)
         return groupmates
     }
    
    func joinGroup(group_code: String, uid: String) async {
            // Fetch the user object by ID
            guard var user = getUserByID(uid) else {
                print("Failed to get User with ID: \(uid)")
                return
            }
        
            do {
                // MARK: getGroupIdByCode is necessary to be async because firebase updates slower than data repo fetches
                if let group_id = await groupRepository.getGroupIdByCode(group_code) {
                    // Update the group_id for the current user
                    user.group_id = group_id
                    userRepository.update(user)
                 }
            }
    }
        
    func createAndJoinGroup(group_name: String, address: String, uid: String) async {
        let group_code = String(Int.random(in: 1000...9999))
        let group_id = UUID().uuidString
        
        do {
            print(group_id)
            let group = Group(id: group_id, address: address, name: group_name, code: group_code)
            groupRepository.create(group)
            await joinGroup(group_code: group_code, uid: uid)
        }
    }
}


extension UserViewModel {
    static func mock() -> UserViewModel {
        // Create and return a mock AuthViewModel with a mock user
        let mockUsers =  [User(id: "test", first_name: "test", last_name: "test", phone_number: "test", email: "test", birthday: "test", group_id: "test")]
        let mockUserViewModel = UserViewModel()
        mockUserViewModel.users = mockUsers
        return mockUserViewModel
    }
    
    static func mockUser() -> User {
        return User(id: "test", first_name: "test", last_name: "test", phone_number: "test", email: "test", birthday: "test", group_id: "test")
    }
}
