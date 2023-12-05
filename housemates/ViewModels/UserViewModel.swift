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
  
    func getGroupCount(_ uid: String) -> Int {
        guard let currentUser = self.users.first(where: { $0.id == uid }), let groupID = currentUser.group_id else {
            return 0
        }
      var groupmates = self.users.filter { $0.group_id == groupID && $0.id != uid }
      // did this so currentUser would appear at the very end.
      groupmates.append(currentUser)
      return groupmates.count
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
    
    func leaveGroup(currUser: User) {
        var currUser = currUser
        currUser.group_id = nil
        userRepository.update(currUser)
    }
    
    func createAndJoinGroup(group_name: String, address: String, uid: String) async {
        let group_code = String(Int.random(in: 1000...9999))
        let group_id = UUID().uuidString
        
        do {
            let group = Group(id: group_id, address: address, name: group_name, code: group_code)
            groupRepository.create(group)
            await joinGroup(group_code: group_code, uid: uid)
        }
    }
    
    // did not do self.users here because already filtered [AllHousematesView]
    func userWithNextBirthday(users: [User]) -> User? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let currentDate = Date()
        
        var daysLeftArray: [(Int, User)] = []
        
        for user in users {
            if let userDate = dateFormatter.date(from: user.birthday) {
                let diffDateComponents = Calendar.current.dateComponents([.day], from: currentDate, to: userDate)
                let daysLeft = diffDateComponents.day ?? 0
                daysLeftArray.append((daysLeft, user))
            }
        }
        
        daysLeftArray.sort { $0.0 < $1.0 }
        
        return daysLeftArray.first?.1
    }
}


extension UserViewModel {
    static func mock() -> UserViewModel {
        // Create and return a mock AuthViewModel with a mock user
        let mockUsers =  [User(id: "xkP2L9pIp5cklnQDD4JYXv0Tow02",
                               first_name: "Sean",
                               last_name: "Pham",
                               phone_number: "1234567899",
                               email: "sean@gmail.com",
                               birthday:  "01-01-2000",
                               group_id: "wwyqNgGYFXMCpMcr9jvI",
                               imageURLString: "https://firebasestorage.googleapis.com:443/v0/b/housemates-3b4be.appspot.com/o/E07030F1-2EDB-46EE-94E1-44C2C8F1D298.jpeg?alt=media&token=208753fd-eb63-4e47-b40e-7fb33ca7345d"),
                          User(id: "test2",
                               first_name: "test2",
                               last_name: "test2",
                               phone_number: "test2",
                               email: "test2",
                               birthday: "test2",
                               group_id: "wwyqNgGYFXMCpMcr9jvI")]
        let mockUserViewModel = UserViewModel()
        mockUserViewModel.users = mockUsers
        return mockUserViewModel
    }
    
    static func mockUser() -> User {
        return User(id: "xkP2L9pIp5cklnQDD4JYXv0Tow02",
                    first_name: "Sean",
                    last_name: "Pham",
                    phone_number: "1234567899",
                    email: "sean@gmail.com",
                    birthday:  "01-01-2000",
                    group_id: "wwyqNgGYFXMCpMcr9jvI",
                    imageURLString: "https://firebasestorage.googleapis.com:443/v0/b/housemates-3b4be.appspot.com/o/E07030F1-2EDB-46EE-94E1-44C2C8F1D298.jpeg?alt=media&token=208753fd-eb63-4e47-b40e-7fb33ca7345d")
}
}
