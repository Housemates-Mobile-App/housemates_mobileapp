//
//  UserRowView.swift
//  housemates
//
//  Created by Daniel Gunawan on 12/9/23.
//

import SwiftUI
import CachedAsyncImage

struct UserRowView: View {
    var rowUser: User
    var body: some View {
        HStack {
            //image
            let imageURL = URL(string: rowUser.imageURLString ?? "")
            
            CachedAsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
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
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text("\(rowUser.first_name.prefix(1).capitalized + rowUser.last_name.prefix(1).capitalized)")
                        
                            .font(.custom("Nunito-Bold", size: 25))
                            .foregroundColor(.white)
                    )
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))

            }
            
            
            //name and username
            VStack (alignment: .leading) {
                Text("\(rowUser.first_name) \(rowUser.last_name)")
                    .font(.custom("Lato-Bold", size: 14))
                
                Text("@\(rowUser.username)")
                    .font(.custom("Lato", size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

#Preview {
    UserRowView(rowUser: UserViewModel.mockUser())
}
