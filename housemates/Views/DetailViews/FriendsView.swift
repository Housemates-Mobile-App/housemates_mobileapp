//
//  FriendsView.swift
//  housemates
//
//  Created by Sean Pham on 12/10/23.
//

import SwiftUI

struct FriendsView: View {
    let currUser: User
    @EnvironmentObject var tabBarViewModel : TabBarViewModel
    @EnvironmentObject var friendInfoViewModel : FriendInfoViewModel

    @State var selectedTab = 0
    var body: some View {
        VStack {
            CustomFriendTabBar(selectedTab: $selectedTab)
            Spacer()
            if selectedTab == 0 {
                // Friends list
            List {
                let friends = friendInfoViewModel.getFriendsList(user: currUser)
                // friends
                if (friends.count > 0) {
                   
                        ForEach(friends) { friend in
                            NavigationLink(destination: OtherProfileView(user: friend)) {
                                UserRowView(rowUser: friend)
                            }
                        }.listRowSeparator(.hidden)
                    }
                }.listStyle(PlainListStyle())

            } else if selectedTab == 1 {
                let friendRequests = friendInfoViewModel.getFriendRequests(user: currUser)
                if (friendRequests.count > 0) {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(friendRequests) { user in
                            NavigationLink(destination: OtherProfileView(user: user)) {
                                HStack {
                                    UserRowView(rowUser: user).padding(.leading)
                                    Spacer()
                                    addFriendButton(currUser: currUser, user: user)
                                    declineButton(currUser: currUser, user: user)
                                        .padding(.trailing)
                                }.padding(.top,2)
                                 .padding(.bottom, 2)
                            }
                        }
                    }
                } else {
                    Text("No Friend Requests")
                        .foregroundColor(.gray)
                        .font(.custom("Nunito-Bold", size: 23))
                        .multilineTextAlignment(.center)
                    Spacer()

                }
            }

        }.onAppear {
            tabBarViewModel.hideTabBar = true
        }
    }
    private func addFriendButton(currUser: User, user: User) -> some View {
        Button(action: {
            friendInfoViewModel.acceptFriendRequest(receive_user: currUser, sent_user: user)
        }) {
            Text("ACCEPT")
            .font(.custom("Lato-Bold", size: 12))
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(.gray.opacity(0.5))
            .cornerRadius(16)
        }
    }
    
    private func declineButton(currUser: User, user: User) -> some View {
        // MARK: Decline Button
        Button(action: {
            friendInfoViewModel.removeFriendRequest(receive_user: currUser, sent_user: user)
        }) {
            Image(systemName: "xmark")
                .foregroundColor(.gray.opacity(0.30))
        }
    }
}

#Preview {
    FriendsView(currUser: UserViewModel.mockUser())
        .environmentObject(TabBarViewModel.mock())
}


struct CustomFriendTabBar : View {
    
    @Binding var selectedTab : Int
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    var body : some View{
        
        HStack{
            
            Button(action: {
                
                self.selectedTab = 0
                
            }) {
                
              Text("Friends")
                    .padding(.vertical,10)
                    .padding(.horizontal,25)
                    .background(self.selectedTab == 0 ? Color(UIColor.systemBackground).opacity(0.9) : Color.clear)
                    .clipShape(Capsule())
            }
            .foregroundColor(self.selectedTab == 0 ? deepPurple : .gray.opacity(0.5))
            
            Button(action: {
                
                self.selectedTab = 1
                
            }) {
                
              Text("Requests")
                .padding(.vertical,10)
                .padding(.horizontal,25)
                .background(self.selectedTab == 1 ? Color(UIColor.systemBackground).opacity(0.9) : Color.clear)
                .clipShape(Capsule())
            }
            .foregroundColor(self.selectedTab == 1 ? deepPurple : .gray.opacity(0.5))
            
            }.padding(8)
        .background(.gray.opacity(0.1))
            .clipShape(Capsule())
            
    }
}
