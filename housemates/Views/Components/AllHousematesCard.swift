//
//  AllHousematesCard.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/9/23.
//
import SwiftUI
import CachedAsyncImage

struct AllHousematesCard: View {
 @EnvironmentObject var authViewModel: AuthViewModel
 var housemate: User

 var body: some View {
     if let currUser = authViewModel.currentUser {
         let isCurrentUser = (currUser.id == housemate.id)
         HStack {
             let imageURL = URL(string: housemate.imageURLString ?? "")
             
             CachedAsyncImage(url: imageURL) { image in
                 image
                     .resizable()
                     .aspectRatio(contentMode: .fill)
                     .clipShape(Circle())
                     .frame(width: 60, height: 60)
                     .padding(.bottom, 5)
                 
             } placeholder: {
     
                 // MARK: Default user profile picture
                 Image(systemName: "person.circle")
                     .resizable()
                     .aspectRatio(contentMode: .fill)
                     .clipShape(Circle())
                     .frame(width: 60, height: 60)
                     .padding(.bottom, 5)
                 
             }
             
             VStack {
                 Text(housemate.first_name)
                     .bold()
                     .foregroundColor(isCurrentUser ? .white : Color(red: 0.439, green: 0.298, blue: 1.0))
                 Text(housemate.is_home != nil ? (housemate.is_home! ? "At Home" : "Not Home") : "Unknown")
                     .foregroundColor(.gray)
             }
             Spacer()
             NavigationLink(destination: isCurrentUser ? AnyView(ProfileView()) : AnyView(HousemateProfileView(housemate: housemate))) {
                 RoundedRectangle(cornerRadius: 10)
                     .frame(width: 80, height: 40)
                     .foregroundColor(isCurrentUser ? .white : Color(red: 0.439, green: 0.298, blue: 1.0))
                     .overlay(
                         Text("View")
                             .foregroundColor(isCurrentUser ? .black : .white)
                     )
             }
         }
         .padding(15)
         .padding([.leading, .trailing], 15)
         .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(isCurrentUser ? Color(red: 0.439, green: 0.298, blue: 1.0).opacity(0.25) : .white.opacity(0.95))
                .padding([.leading, .trailing], 15)
         )
         .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black.opacity(0.25), lineWidth: 1)
                .padding([.leading, .trailing], 15)
         )
     }
 }
}

struct AllHousematesCard_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(user_id: "L9pIp5cklnQDD4JYXv0Tow02", first_name: "Bob", last_name: "Portis", phone_number: "9519012", email: "danielfg@gmail.com", birthday: "02/02/2000")
        AllHousematesCard(housemate:user)
            .environmentObject(AuthViewModel.mock())
            .environmentObject(UserViewModel())
           
    }
    
}
