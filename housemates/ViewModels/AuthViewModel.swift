//
//  AuthViewModel.swift
//  housemates
//
//  Code referenced from https://www.youtube.com/watch?v=QJHmhLGv-_0&ab_channel=AppStuff
//  Created by Sean Pham on 10/31/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formisValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    private let userRepository = UserRepository()
    private let groupRepository = GroupRepository()

    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    init () {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Failed to log in: \(error.localizedDescription)")
        }
    }
    
    // TODO: Change birthday to date type and phone_number to int
    func createUser(withEmail email: String, password: String, first_name: String, last_name: String, phone_number: String, birthday: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, first_name: first_name, last_name: last_name, phone_number: phone_number, email: email, birthday: birthday)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id!).setData(encodedUser)
            await fetchUser()
        }  catch {
            print("Failed to create user: \(error.localizedDescription)")
        }
    }
    
    // TODO: Move to group data repository
    func joinGroup(_ group_code: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
                
        do {
            if let group_id = await groupRepository.getGroupIdByCode(group_code) {
                _ = try await Firestore.firestore().collection("users").document(uid).setData(["group_id": group_id], merge: true)
                await fetchUser()
            }
        }  catch {
            print("Failed to assign group to User: \(error.localizedDescription)")
        }
    }
    
    // TODO: Move to group data repository
    func createAndJoinGroup(group_name: String, address: String) async throws {
        
        let group_code = String(Int.random(in: 1000...9999))
        let id = Firestore.firestore().collection("groups").document().documentID
        do {
            let group = Group(id: id, address: address, name: group_name, code: group_code)
            let encodedUser = try Firestore.Encoder().encode(group)
            try await Firestore.firestore().collection("groups").document(group.id!).setData(encodedUser)
            try await joinGroup(group_code)
            await fetchUser()
        }  catch {
            print("Failed to assign group to User: \(error.localizedDescription)")
        }

    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Failed to sign out: \(error.localizedDescription)")
        }
    }

}

