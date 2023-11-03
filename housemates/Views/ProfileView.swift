//
//  ProfileView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    var body: some View {
        VStack{
            Text("Profile")
            
            Section("Account") {
                Button {
                    authViewModel.signOut()
                } label: {
                    Text("Sign Out")
                }
            }
        }
    }
}

//#Preview {
//    ProfileView()
//}
