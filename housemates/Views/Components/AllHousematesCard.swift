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
             Spacer()
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
         .padding(15)
         .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(isCurrentUser ? .pink.opacity(0.95) : .white.opacity(0.95)) // Adds a white fill
         )
         .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black.opacity(0.25), lineWidth: 1) // Adds a black stroke
         )
     }
 }
}

struct AllHousematesCard_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(first_name: "Bob", last_name: "Portis", phone_number: "9519012", email: "danielfg@gmail.com", birthday: "02/02/2000")
        AllHousematesCard(housemate:user)
            .environmentObject(AuthViewModel.mock())
            .environmentObject(UserViewModel())
           
    }
    
}
