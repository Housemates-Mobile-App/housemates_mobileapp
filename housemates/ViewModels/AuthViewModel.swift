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
import FirebaseStorage

protocol AuthenticationFormProtocol {
    var formisValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isLoading = false
    
    init () {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func setUser(user: User) async {
        self.currentUser = user
    }
    
    
    func fetchUser() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            print("SNAPSHOT: \(snapshot.data())")
            self.currentUser = try? snapshot.data(as: User.self)
        } catch {
            print("Failed to fetch user: \(error.localizedDescription)")
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
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Failed to sign out: \(error.localizedDescription)")
        }
    }
    
//    func saveProfilePicture(image: UIImage) async -> Bool {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            print("ERROR: Counld not get current user ID")
//            return false
//        }
//        
//        let photoID = UUID().uuidString
//        let storage = Storage.storage()
//        let storageRef = storage.reference().child("\(photoID).jpeg")
//        
//        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else {
//            print("ERROR: Could not resize image")
//            return false
//        }
//        
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpg"
//        
//        var imageURLString = ""
//        
//        // MARK: Save image to Storage and get URL
//        do {
//            let _ = try await storageRef.putDataAsync(resizedImage, metadata: metadata)
//            do {
//                let imageURL = try await storageRef.downloadURL()
//                imageURLString = "\(imageURL)"
//            } catch {
//                print("ERROR: Could not get imageURL after saveing image \(error.localizedDescription)")
//                return false
//            }
//        } catch {
//            print("ERROR: Could not upload image to FirebaseStorage")
//            return false
//        }
//        
//        // MARK: Update user struct and Firestore document
//        do {
//            try await Firestore.firestore().collection("users").document(uid).setData(["imageURLString": imageURLString], merge: true)
//            await fetchUser()
//            return true
//        } catch {
//            print("ERROR: Could not update data for user")
//            return false
//        }
//
//        
//    }

}

