//
//  SearchDisplayView.swift
//  housemates
//
//  Created by Daniel Gunawan on 12/9/23.
//

import SwiftUI

struct SearchDisplayView: View {
    var currUser: User
    @EnvironmentObject var userViewModel : UserViewModel
    @State private var searchUser: String = ""
    
    var body: some View {
        let housemates = userViewModel.getUserGroupmates(currUser.id ?? "")
        
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
                if (housemates.count > 0) {
                    Section(header: Text("Housemates")
                        .font(.custom("Lato-Bold", size: 16))
                        .foregroundColor(.primary)) {
                            ForEach(housemates) { housemate in
                                NavigationLink(destination: HousemateProfileView(housemate: housemate)) {
                                    UserRowView(rowUser: housemate)
                                }
                            }.listRowSeparator(.hidden)
                        }
                }
                // friends
                Section(header: Text("Friends")
                  .font(.custom("Lato-Bold", size: 16))
                  .foregroundColor(.primary)) {
                      Text("friendz")
                  }
                
                // people
                Section(header: Text("People")
                  .font(.custom("Lato-Bold", size: 16))
                  .foregroundColor(.primary)) {
                      Text("People")
                  }
                
            }.listStyle(PlainListStyle())
        }
    }
    private func search(searchText: String, userList: [User]) -> [User] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return userList
        } else {
            return userList.filter { tempUser in
                return tempUser.username.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

#Preview {
    SearchDisplayView(currUser: UserViewModel.mockUser())
        .environmentObject(UserViewModel())
}
