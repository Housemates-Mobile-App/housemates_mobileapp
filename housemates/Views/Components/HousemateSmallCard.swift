//
//  HousemateSmallCard.swift
//  housemates
//
//  Created by Sean Pham on 12/10/23.
//

import SwiftUI
import CachedAsyncImage

struct HousemateSmallCard: View {
    let user: User
    let imageSize = UIScreen.main.bounds.width * 0.14
    let componentOffset = UIScreen.main.bounds.height * 0.063

    var body: some View {
            let imageURL = URL(string: user.imageURLString ?? "")
            
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1.5)
                .frame(width: 120, height: 120)
                .padding(.all, 2)
            VStack {
                CachedAsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: imageSize, height: imageSize)
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
                        .frame(width: imageSize, height: imageSize)
                        .overlay(
                            Text("\(user.first_name.prefix(1).capitalized + user.last_name.prefix(1).capitalized)")
                            
                                .font(.custom("Nunito-Bold", size: 18))
                                .foregroundColor(.white)
                        )
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                }
                
                                // MARK: Housemate name
                                Text("\(user.first_name)")
                                    .font(.system(size: 14.5))
                                    .bold()
                                    .foregroundColor(.primary)
                
                                // MARK: Housemate username
                                Text("@\(user.username)")
                                    .font(.custom("Lato", size: 11))
            }.offset(y: -componentOffset * 0.05)
        }
    }
}

#Preview {
    HousemateSmallCard(user: UserViewModel.mockUser())
}
