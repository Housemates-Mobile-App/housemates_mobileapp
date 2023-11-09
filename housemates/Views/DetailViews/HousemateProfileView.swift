//
//  HousemateProfileView.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/2/23.
//

import SwiftUI

struct HousemateProfileView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    let housemate: User
    var body: some View {
        VStack{
            Text("Housemate Profile")
            
            let imageURL = URL(string: housemate.imageURLString ?? "")
            
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
                    .foregroundColor(.gray)
                    .padding(5)
                
            } placeholder: {
    
                // MARK: Default user profile picture
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
                    .foregroundColor(.gray)
                    .padding(5)
                
            }
            
            Text(housemate.first_name)
            if let isHome = housemate.is_home {
                let userStatus = isHome ? "home" : "away"
                Text("\(housemate.first_name) is currently \(userStatus)")
            } else {
                Text("\(housemate.first_name) is currently unknown")
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

//#Preview {
//    HousemateProfileView()
//}
