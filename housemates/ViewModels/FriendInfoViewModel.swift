//
//  FriendInfoViewModel.swift
//  housemates
//
//  Created by Sean Pham on 12/9/23.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

class FriendInfoViewModel: ObservableObject {
    private let friendInfoRepository = FriendInfoRepository()
    
    @Published var friendsInfos: [FriendInfo] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        friendInfoRepository.$friendInfos
            .receive(on: DispatchQueue.main)
            .sink { updatedFriendInfos in
                self.friendsInfos = updatedFriendInfos
            }
            .store(in: &self.cancellables)
        
    }
    // MARK: Given a list of users, return a list of the user_ids
    func getUserIDs(users: [User]) -> [String] {
        return users.map { $0.user_id }
    }
    
    // MARK: Get friends list for for a user
    func getFriendsList(user: User) -> [User] {
        if let friendInfo = self.friendsInfos.filter({ $0.user_id == user.user_id }).first {
            return friendInfo.friendsList
        }
        return []
    }
    
    // MARK: Get friend requests for a user
    func getFriendRequests(user: User) -> [User]{
        if let friendInfo = self.friendsInfos.filter({ $0.user_id == user.user_id }).first {
            return friendInfo.friendRequests
        }
        return []
    }
    
    // MARK: Send friend request from a user to another user
    func sendFriendRequest(from: User, to: User) {
        // Get friend info for sent to user
        if var friendInfo = self.friendsInfos.filter({ $0.user_id == to.user_id }).first {
            var newFriendRequests = friendInfo.friendRequests
            // If the user_id from the sender is not in the friend requests list of the sent to user, append and update
            if !getUserIDs(users: newFriendRequests).contains(from.user_id) {
                newFriendRequests.append(from)
                friendInfo.friendRequests = newFriendRequests
                friendInfoRepository.update(friendInfo)
            }
        }
    }
    
    
    
    // Helper function to check if two users are friends
    private func areFriends(user1: User, user2: User) -> Bool {
        if let friendInfo = self.friendsInfos.first(where: { $0.user_id == user1.user_id }) {
            return getUserIDs(users: friendInfo.friendsList).contains(user2.user_id)
        }
        return false
    }
    
    // Helper function to check if a friend request has been sent from one user to another
    private func hasSentFriendRequest(from: User, to: User) -> Bool {
        if let friendInfo = self.friendsInfos.first(where: { $0.user_id == to.user_id }) {
            //            print("\(to.first_name) has a friend request list of \(friendInfo.friendRequests)")
            return getUserIDs(users: friendInfo.friendRequests).contains(from.user_id)
        }
        return false
    }
    
    // MARK: Check the status of user friend status.
    // curr_user is the current logged in user, viewed_user is the user curr_user is viewing
    // If both are friends, return "friends"
    // If curr_user has already sent a friend request, return "pending"
    // If the viewed_user has sent a request already to the curr_user, return "accept"
    // If the curr_user and viewed_user are not affiliated yet, return "None"
    func checkFriendStatus(viewed_user: User, curr_user: User) -> String {
        // Check if both users are friends
        if areFriends(user1: curr_user, user2: viewed_user) {
            return "friends"
        }
        
        // Check if curr_user has sent a friend request
        if hasSentFriendRequest(from: curr_user, to: viewed_user) {
            return "pending"
        }
        
        // Check if viewed_user has sent a friend request to curr_user
        if hasSentFriendRequest(from: viewed_user, to: curr_user) {
            return "accept"
        }
        
        // If the users are not affiliated yet
        return "None"
    }
    
    // MARK: Remove sent_user from received user friend request list
    func removeFriendRequest(receive_user: User, sent_user: User) {
        if var friendInfo = self.friendsInfos.first(where: { $0.user_id == receive_user.user_id }) {
            // Remove the friend request from the friend requests list
            friendInfo.friendRequests = friendInfo.friendRequests.filter { $0.user_id != sent_user.user_id }
            friendInfoRepository.update(friendInfo)
        }
    }
    
    // MARK: Add each user to friends lists and remove request from from receive_user
    func acceptFriendRequest(receive_user: User, sent_user: User) {
        // Add sent_user to receive_user's friend list and remove the friend request from the receive_user
        if var receiveFriendInfo = self.friendsInfos.first(where: { $0.user_id == receive_user.user_id }) {
            var receiveNewFriendsList = receiveFriendInfo.friendsList
            receiveNewFriendsList.append(sent_user)
            receiveFriendInfo.friendsList = receiveNewFriendsList
            // MARK: CANNOT USE REMOVEFRIENDREQUEST FUNCTION BECAUSE OVERLAPPING UPDATE TRANSACTIONS (EVEN WITH ASYNC)
            receiveFriendInfo.friendRequests = receiveFriendInfo.friendRequests.filter { $0.user_id != sent_user.user_id }
            friendInfoRepository.update(receiveFriendInfo)
            
        }
        
        // Add receive_user to sent friend's list
        if var sentFriendInfo = self.friendsInfos.first(where: { $0.user_id == sent_user.user_id }) {
            var sentNewFriendsList = sentFriendInfo.friendsList
            sentNewFriendsList.append(receive_user)
            sentFriendInfo.friendsList = sentNewFriendsList
            friendInfoRepository.update(sentFriendInfo)

        
        }
    }
    
    // MARK: Remove Friend from each users friends list
    func removeFriend(user1: User, user2: User) {
        if var friendInfo1 = self.friendsInfos.first(where: { $0.user_id == user1.user_id }) {
            // Remove the friend from the friends list
            let new_friends_1 = friendInfo1.friendsList.filter { $0.user_id != user2.user_id }
            friendInfo1.friendsList = new_friends_1
            friendInfoRepository.update(friendInfo1)
        }
        
        if var friendInfo2 = self.friendsInfos.first(where: { $0.user_id == user2.user_id }) {
            // Remove the friend from the friends list
            let new_friends_2 = friendInfo2.friendsList.filter { $0.user_id != user1.user_id }
            friendInfo2.friendsList = new_friends_2
            friendInfoRepository.update(friendInfo2)
        }
    }
}
