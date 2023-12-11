//
//  OtherProfileView.swift
//  housemates
//
//  Created by Sean Pham on 12/10/23.
//

import SwiftUI

struct OtherProfileView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var tabBarViewModel : TabBarViewModel
    @EnvironmentObject var friendInfoViewModel : FriendInfoViewModel
    
    let user: User
    var body: some View {
        // MARK: If authenticated user and viewed user are in the same group, show housemate profile view
        if let currUser = authViewModel.currentUser {
            if currUser.group_id == user.group_id {
                HousemateProfileView(housemate: user)
            } else {
                // MARK: Otherwise, show the user profile view
                UserProfileView(user: user, currentUser: currUser)
            }
        }
    }
}
//#Preview {
//    OtherProfileView()
//}
