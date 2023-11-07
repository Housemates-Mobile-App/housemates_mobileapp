//
//  ProfileView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI


struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var groupRepository = GroupRepository()
    @State private var group: Group?
    @State private var group_code: String?

    var body: some View {
        if let user = authViewModel.currentUser {
            VStack {
                if let userProfileImageURL = user.imageURLString {
                    // MARK: Get user profile picture from firebase storage

                    Text("hello")
                    
                } else {
                    // MARK: Default user profile picture
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 5)
                        .foregroundColor(.gray)
                        .padding(20)
                }
                
                Button {
                    print("Picture Picker")
                } label: {
                    Text("Edit Photo")
                }
                
                
                // MARK: Profile setting menu
                List {
                    Section("Account") {
                        HStack {
                            if let group_code = group_code {
                                Text("Group Code: \(group_code)")
                            } else {
                                Text("Group Code: N/A")
                            }
                        }
                        
                        Button {
                            print("Leaving group...")
                        } label: {
                            Text("Leave Group")
                        }
                        
                        Button {
                            authViewModel.signOut()
                        } label: {
                            Text("Sign Out")
                        }
                    }.task {
                        group = groupRepository.filterGroupsByID(user.group_id!)
                        group_code = group?.code
                    }
                }
            }
        }
    }
}


// MARK: Preview causes this view to crash due to unwrapping of user (not sure what it is)

//#Preview {
//    ProfileView()
//}



