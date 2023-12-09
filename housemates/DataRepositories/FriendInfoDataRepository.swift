//
//  FriendInfoDataRepository.swift
//  housemates
//
//  Created by Sean Pham on 12/9/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class FriendInfoRepository: ObservableObject {
    private let path: String = "friendInfos"
    private let store = Firestore.firestore()

    @Published var friendInfos: [FriendInfo] = []
    private var cancellables: Set<AnyCancellable> = []

    init() {
        self.get()
    }

    func get() {
        store.collection(path)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting posts: \(error.localizedDescription)")
                    return
                }
                
                self.friendInfos = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: FriendInfo.self)
                } ?? []
                
            }
    }

    // MARK: CRUD methods
    func create(_ friendInfo: FriendInfo) {
            do {
                let newFriendInfo = friendInfo
                _ = try store.collection(path).addDocument(from: newFriendInfo)
            } catch {
                fatalError("Unable to add friend info: \(error.localizedDescription).")
            }
    }
    
    func update(_ friendInfo: FriendInfo) {
        guard let friendInfoID = friendInfo.id else { return }
        
        do {
          try store.collection(path).document(friendInfoID).setData(from: friendInfo)
        } catch {
          fatalError("Unable to update friend info: \(error.localizedDescription).")
        }
      }
}
