//
//  HousemateProfileView.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/2/23.
//

import SwiftUI

struct HousemateProfileView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    // this is currently based on the curr user, need to alter it to be based on another housemate thru their id
    var body: some View {
        if let user = authViewModel.currentUser {
            VStack{
                Text("Housemate Profile")
                
                Image("danielFace")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
                
                Text(user.first_name)
                if let isHome = user.is_home {
                    let userStatus = isHome ? "home" : "away"
                    Text("\(user.first_name) is currently \(userStatus)")
                } else {
                    Text("\(user.first_name) is currently unknown")
                }
                Text("Statistics")
                HStack {
                    Text("Total Tasks Completed")
                }
                Divider()
                HStack {
                    Text("Currently Using")
                }
                Divider()
            }
        }
    }
}

#Preview {
    HousemateProfileView()
}
