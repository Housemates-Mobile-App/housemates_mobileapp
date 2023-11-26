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
                    .frame(width: 50, height: 50)
//                    .padding(.bottom, 2.5)
            } placeholder: {
    
                // MARK: Default user profile picture
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
//                    .padding(.bottom, 2.5)
            }
            
            Text("\(housemate.first_name.lowercased()) \(housemate.last_name.first?.lowercased() ?? "")")
                
                .font(.custom("Lato", size: 12))
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
