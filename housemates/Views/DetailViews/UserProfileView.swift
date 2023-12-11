//
//  UserProfileView.swift
//  housemates
//
//  Created by Sean Pham on 12/10/23.
//

import SwiftUI
import CachedAsyncImage

struct UserProfileView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var taskViewModel : TaskViewModel
    @EnvironmentObject var tabBarViewModel : TabBarViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var friendInfoViewModel : FriendInfoViewModel
    @State private var isPopoverPresented = false
    @Environment(\.presentationMode) var presentationMode
    
    let user: User
    let currentUser: User
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    var body: some View {
        let imageSize = UIScreen.main.bounds.width * 0.25
        let componentOffset = UIScreen.main.bounds.height * 0.063
        
        ZStack {
            
            // MARK: Wave Background
            VStack {
                ZStack {
                    NewWave()
                        .fill(deepPurple)
                        .frame(height: UIScreen.main.bounds.height * 0.20)
                    
                    let imageURL = URL(string: user.imageURLString ?? "")
                    
                    CachedAsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageSize, height: imageSize)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .offset(y: UIScreen.main.bounds.height * 0.10)
                    } placeholder: {
                        // Default user profile picture
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(red: 0.6, green: 0.6, blue: 0.6), Color(red: 0.8, green: 0.8, blue: 0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: imageSize, height: imageSize)
                            .overlay(
                                Text("\(user.first_name.prefix(1).capitalized + user.last_name.prefix(1).capitalized)")
                                
                                    .font(.custom("Nunito-Bold", size: 40))
                                    .foregroundColor(.white)
                            )
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .offset(y: UIScreen.main.bounds.height * 0.10)
                    }
                }
                // MARK: Housemate name
                Text("\(user.first_name) \(user.last_name)")
                    .font(.system(size: 26))
                    .bold()
                    .foregroundColor(.black)
                    .offset(y: componentOffset)
                
                // MARK: Housemate username
                Text("@\(user.username)")
                    .font(.custom("Lato", size: 17))
                    .offset(y: componentOffset)
                
                // MARK: Button stating friend status and actionable button
                let status = friendInfoViewModel.checkFriendStatus(viewed_user: user, curr_user: currentUser)
                if status == "None" {

                    addFriendButton(currUser: currentUser, user: user).offset(y: componentOffset)
                } else if status == "pending" {
                    pendingCard().offset(y: componentOffset)
                } else if status == "accept" {
                    acceptDeclineButton(currUser: currentUser, user: user).offset(y: componentOffset)
                } else {
                    friendsCard(currUser: currentUser, user: user).offset(y: componentOffset)
                }
                
                
                
                // MARK: Lives with horizontal scroll view
                if status == "friends" {
                    let userHousemates = userViewModel.getUserGroupmates(user.user_id)
                    if userHousemates.count > 0 {
                        VStack(spacing: 10) {
                            HStack {
                                Text("Lives with:")
                                    .font(.custom("Nunito-Bold", size: 22))
                                    .bold()
                                Spacer()
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10){
                                    ForEach(userHousemates) { user in
                                        NavigationLink(destination: OtherProfileView(user: user)) {
                                            HousemateSmallCard(user: user)
                                        }
                                    }
                                }
                            }
                        }.offset(y: componentOffset * 1.30)
                        .padding(.leading, 35)
                    }
            }
                
                Spacer()
                
                
            }.edgesIgnoringSafeArea(.top)
            // END OF ZSTACK
        }.navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton())
        .onAppear {
            tabBarViewModel.hideTabBar = true
        }}
    
    private func backButton() -> some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .font(.system(size:18))
                    .bold()
                    .padding(.vertical)
            }
        }
    }
    
    private func addFriendButton(currUser: User, user: User) -> some View {
        Button(action: {
            friendInfoViewModel.sendFriendRequest(from: currUser, to: user)
        }) {
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(deepPurple)
                    .frame(width: UIScreen.main.bounds.width * 0.80, height: UIScreen.main.bounds.height * 0.05)
                    .overlay(
                        HStack(spacing: 5) {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .foregroundColor(.white)
                            
                            Text("Add Friend")
                                .foregroundColor(.white)
                                .font(.custom("Lato-Bold", size: 13))
                        }
                    )
            }
        }
    }
    
    private func friendsCard(currUser: User, user: User) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(deepPurple)
                .frame(width: UIScreen.main.bounds.width * 0.60, height: UIScreen.main.bounds.height * 0.05)
                .overlay(
                    Text("You are \(user.first_name) are friends!")
                        .foregroundColor(.white)
                        .font(.custom("Lato-Bold", size: 13))
                )
            
            Menu {
                Button {
                    friendInfoViewModel.removeFriend(user1: currUser, user2: user)
                } label: {
                    Text("Remove Friend")
                        .font(.custom("Lato", size: 12))

                }
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .fill(deepPurple)
                    .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.height * 0.05)
                    .overlay(
                        Image(systemName: "person.crop.circle.badge.minus")
                            .foregroundColor(.white)
                            .font(.system(size:18))
                            .bold()
                            .padding(.vertical)
                    )
            }
        }
    }

    
    private func pendingCard() -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(deepPurple.opacity(0.50))
                .frame(width: UIScreen.main.bounds.width * 0.80, height: UIScreen.main.bounds.height * 0.05)
                .overlay(
                    Text("Pending")
                        .foregroundColor(.white)
                        .font(.custom("Lato-Bold", size: 13))
                )
        }
    }
    
    private func acceptDeclineButton(currUser: User, user: User) -> some View {
        HStack {
            // MARK: Accept Button
            Button(action: {
                friendInfoViewModel.acceptFriendRequest(receive_user: currUser, sent_user: user)
            }) {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(deepPurple)
                    .frame(width: UIScreen.main.bounds.width * 0.40, height: UIScreen.main.bounds.height * 0.05)
                    .overlay(
                        HStack(spacing: 5) {
                            Image(systemName: "person.crop.circle.badge.checkmark")
                                .foregroundColor(.white)
                            
                            Text("Accept Friend")
                                .foregroundColor(.white)
                                .font(.custom("Lato-Bold", size: 13))
                        }
                    )
                    
                }
           // MARK: Decline Button
            Button(action: {
                friendInfoViewModel.removeFriendRequest(receive_user: currUser, sent_user: user)
            }) {
            
                RoundedRectangle(cornerRadius: 10)
                    .fill(deepPurple)
                    .frame(width: UIScreen.main.bounds.width * 0.40, height: UIScreen.main.bounds.height * 0.05)
                    .overlay(
                        HStack(spacing: 5) {
                            Image(systemName: "person.crop.circle.badge.xmark")
                                .foregroundColor(.white)
                            
                            Text("Decline")
                                .foregroundColor(.white)
                                .font(.custom("Lato-Bold", size: 13))
                        }
                    )
                }
        }
    }
}


#Preview {
    UserProfileView(user: UserViewModel.mockUser(), currentUser: UserViewModel.mockUser() )
        .environmentObject(AuthViewModel())
        .environmentObject(TaskViewModel())
        .environmentObject(TabBarViewModel())
        .environmentObject(FriendInfoViewModel())
}
