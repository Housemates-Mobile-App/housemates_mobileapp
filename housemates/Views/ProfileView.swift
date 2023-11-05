//
//  ProfileView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @ObservedObject var userRepoModel = UserRepository()
    @State private var isUserHome: Bool = false //has a default val for safety ig
    
    //initialized it here since its based on curr user
    // also setting false as default val if nil. good or bad?
//    init() {
//        _isUserHome = State(initialValue: authViewModel.currentUser?.is_home ?? false)
//    }
    
    var body: some View {
        VStack {
            if let user = authViewModel.currentUser {
                VStack{
                    Text("Profile")
                    
                    Image("danielFace")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 5)
                    Text("\(user.first_name)")
                    HStack {
                        Text("Location")
                        Spacer()
                        Toggle(isOn: $isUserHome) {
                        }
                        .onChange(of: isUserHome) { newIsHome in
                            updateUserHomeStatus(newIsHome)
                        }
                        
                    }
                    Divider()
                    HStack {
                        Text("Group Code: 1294")
                    }
                    Divider()
                    HStack {
                        // will need to make this a button or smtg.
                        Text("Leave Group")
                    }
                    Divider()
                    
                    Section("Account") {
                        Button {
                            authViewModel.signOut()
                        } label: {
                            Text("Sign Out")
                        }
                    }
                }
            }
        }.onAppear {
            isUserHome = authViewModel.currentUser?.is_home ?? false
        }
    }
    func updateUserHomeStatus(_ isHome: Bool) {
        // Call the function to update the Firestore database with the new is_home value
        if let currentUser = authViewModel.currentUser {
            userRepoModel.updateUser(currentUser, fields:["is_home": isHome])
        }
    }
}

//#Preview {
//    ProfileView()
//}
