//
//  HousemateCircleComponent.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/13/23.
//

import SwiftUI

struct HousemateCircleComponent: View {
    let housemate: User
    
    var body: some View {
        VStack {
            let imageURL = URL(string: housemate.imageURLString ?? "")
            
            AsyncImage(url: imageURL) { image in
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
                    .background(
                        // Gradient stroke overlay
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.orange, Color.pink]),
                                    startPoint: .bottomLeading,
                                    endPoint: .topTrailing
                                ),
                                lineWidth: 3
                            )
                            .frame(width: 60, height: 60)
                    )
                
            }
            
            Text("\(housemate.first_name.lowercased()) \(housemate.last_name.first?.lowercased() ?? "")")
                .font(.system(size:11))
        }
        .frame(width: 80)
        .padding(.vertical)
    }
}

#Preview {
    HousemateCircleComponent(housemate: UserViewModel.mockUser())
}
