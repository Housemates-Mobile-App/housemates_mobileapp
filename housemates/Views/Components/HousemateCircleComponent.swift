//
//  HousemateCircleComponent.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/13/23.
//

import SwiftUI
import CachedAsyncImage
struct HousemateCircleComponent: View {
    let housemate: User
    
    var body: some View {
        VStack {
            let imageURL = URL(string: housemate.imageURLString ?? "")
            
            CachedAsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 58, height: 58)
//                    .padding(.bottom, 2.5)
            } placeholder: {
    
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.gray.opacity(0.4)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 58, height: 58)
                    .overlay(
                        Text("\(housemate.first_name.prefix(1).capitalized + housemate.last_name.prefix(1).capitalized)")
                          
                            .font(.custom("Nunito-Bold", size: 25))
                            .foregroundColor(.white)
                    )
            }
            
            Text("\(housemate.first_name.lowercased()) \(housemate.last_name.first?.lowercased() ?? "")")
                
                .font(.custom("Lato", size: 13))
        }
     
//        .padding(.vertical, 10)
    }
}

struct HousemateCircleComponent_Previews: PreviewProvider {
  static var previews: some View {
    HousemateCircleComponent(housemate: UserViewModel.mockUser())
  }
  
}
//#Preview {
//    HousemateCircleComponent(housemate: UserViewModel.mockUser())
//}
