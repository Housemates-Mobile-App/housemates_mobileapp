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
                    .frame(width: 70, height: 70)
                    .padding(.bottom, 5)
            } placeholder: {
    
                // MARK: Default user profile picture
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 70, height: 70)
                    .foregroundColor(.gray)
                    .padding(.bottom, 5)
            }
            
            Text("\(housemate.first_name.lowercased()) \(housemate.last_name.first?.lowercased() ?? "")")
                .font(.system(size:11))
        }
        .frame(width: 80)
        .padding(.vertical, 10)
    }
}

//#Preview {
//    HousemateCircleComponent(housemate: UserViewModel.mockUser())
//}
