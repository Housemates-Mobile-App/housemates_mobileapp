//
//  AllHousematesCard.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/9/23.
//

import SwiftUI

struct AllHousematesCard: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var housemate: User
    
    var body: some View {
        if let currUser = authViewModel.currentUser {
            let isCurrentUser = (currUser.id == housemate.id)
            HStack {
                VStack {
                    Text(housemate.first_name)
                        .bold()
                        .foregroundColor(isCurrentUser ? .white : .pink)
                    Text(housemate.is_home != nil ? (housemate.is_home! ? "At Home" : "Not Home") : "Unknown")
                        .foregroundColor(.gray)
                }
                NavigationLink(destination: isCurrentUser ? AnyView(ProfileView()) : AnyView(HousemateProfileView(housemate: housemate))) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 80, height: 40)
                        .foregroundColor(isCurrentUser ? .white : .pink)
                        .overlay(
                            Text("View")
                                .foregroundColor(isCurrentUser ? .black : .white)
                        )
                }
            }
            .padding()
            .background(isCurrentUser ? .pink : .white)
            .cornerRadius(10)
        }
    }
}

//#Preview {
//    AllHousematesCard()
//}
