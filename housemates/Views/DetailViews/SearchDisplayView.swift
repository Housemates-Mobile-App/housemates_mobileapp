//
//  SearchDisplayView.swift
//  housemates
//
//  Created by Daniel Gunawan on 12/9/23.
//

import SwiftUI

struct SearchDisplayView: View {
    var currUser: User
    @EnvironmentObject var tabBarViewModel : TabBarViewModel
    @EnvironmentObject var userViewModel : UserViewModel
//    @EnvironmentObject var friendInfoViewModel : FriendInfoViewModel
    @State private var searchUser: String = ""
    
//    @State private var cachedPeople: [User] = []
    @State private var cachedHousemates: [User] = []
//    @State private var cachedFriends: [User] = []
//    @State private var filteredPeople: [User] = []
    @State private var filteredHousemates: [User] = []
//    @State private var filteredFriends: [User] = []
    
    var body: some View {
//        let housemates = search(searchText: searchUser, userList: userViewModel.getUserGroupmates(currUser.id ?? ""))
//        let friends = search(searchText: searchUser, userList: friendInfoViewModel.getFriendsList(user: currUser))
//        let otherUsers = search(searchText: searchUser, userList: userViewModel.getUsersExceptCurrUser(currUser.id ?? ""))
        
        VStack(spacing: 0) {
            //search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding([.top, .bottom], 5)
                    .padding(.leading, 10)
                
                TextField("Name, @username", text: $searchUser)
                    .font(.custom("Lato", size: 14))
                    .foregroundColor(.primary.opacity(0.75))
                    .padding(.vertical, 10)
                    .background(Color.clear)
            }
            .background(Color(.systemGray5))
            .cornerRadius(15)
            .padding(.horizontal)
            
            List {
                // housemates
                if (filteredHousemates.count > 0) {
                    Section(header: Text("Housemates")
                        .font(.custom("Lato-Bold", size: 16))
                        .foregroundColor(.primary)) {
                            ForEach(filteredHousemates) { housemate in
                                NavigationLink(destination: OtherProfileView(user: housemate)) {
                                    UserRowView(rowUser: housemate)
                                }
                            }.listRowSeparator(.hidden)
                        }
                }
                // friends
//                if (filteredFriends.count > 0) {
//                    Section(header: Text("Friends")
//                        .font(.custom("Lato-Bold", size: 16))
//                        .foregroundColor(.primary)) {
//                            ForEach(filteredFriends) { friend in
//                                NavigationLink(destination: OtherProfileView(user: friend)) {
//                                    UserRowView(rowUser: friend)
//                                }
//                            }.listRowSeparator(.hidden)
//                        }
//                }
                
                // people
//                if (searchUser.count > 0 && filteredPeople.count > 0) {
//                    Section(header: Text("People")
//                        .font(.custom("Lato-Bold", size: 16))
//                        .foregroundColor(.primary)) {
//                            ForEach(filteredPeople) { person in
//                                NavigationLink(destination: OtherProfileView(user: person)) {
//                                    UserRowView(rowUser: person)
//                                }
//                            }.listRowSeparator(.hidden)
//                        }
//                }
                
            }.listStyle(PlainListStyle())
        }.onAppear {
            tabBarViewModel.hideTabBar = true
            
            cachedHousemates = userViewModel.getUserGroupmates(currUser.id ?? "")
            
//            let excludeUserIdsFriends: Set<String> = Set([currUser.user_id] + cachedHousemates.map { $0.user_id })
//            cachedFriends = friendInfoViewModel.getFriendsList(user: currUser)
            
            // dont want to include housemates, friends, or curr user
//            let excludeUserIdsPeople: Set<String> = Set([currUser.user_id] + cachedHousemates.map { $0.user_id } + cachedFriends.map { $0.user_id })
//            cachedPeople = userViewModel.users.filter { !excludeUserIdsPeople.contains($0.user_id) }
//            
            filteredHousemates = search(searchText: searchUser, userList: cachedHousemates)
//            filteredFriends = search(searchText: searchUser, userList: cachedFriends)
//            filteredPeople = search(searchText: searchUser, userList: cachedPeople)
        }
        .onChange(of: searchUser) { newValue in
            filteredHousemates = search(searchText: newValue, userList: cachedHousemates)
//            filteredFriends = search(searchText: newValue, userList: cachedFriends)
//            filteredPeople = search(searchText: newValue, userList: cachedPeople)
        }
    }
    
    private func search(searchText: String, userList: [User]) -> [User] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return userList
        } else {
            let lowercasedSearchText = searchText.lowercased()
            return userList.filter { user in
                return user.username.lowercased().contains(lowercasedSearchText) ||
                user.first_name.lowercased().contains(lowercasedSearchText) ||
                user.last_name.lowercased().contains(lowercasedSearchText)
            }
        }
    }
}

#Preview {
    SearchDisplayView(currUser: UserViewModel.mockUser())
        .environmentObject(UserViewModel())
        .environmentObject(FriendInfoViewModel())
}
