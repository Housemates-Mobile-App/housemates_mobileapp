//
//  TaskHousematesView.swift
//  housemates
//
//  Created by Bernard Sheng on 11/10/23.
//

import SwiftUI

struct TaskHousematesView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    var body: some View {
      if let user = authViewModel.currentUser {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            Spacer()
            ForEach(userViewModel.getUserGroupmatesInclusive(user.id!)) { mate in
              let imageURL = URL(string: mate.imageURLString ?? "")
              
              
              AsyncImage(url: imageURL) {
                image in image
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 60, height: 60)
                  .clipShape(Circle())
                  .overlay(Circle().stroke(Color.purple, lineWidth: 4))
                  .foregroundColor(.gray)
                  .padding(5)
              } placeholder: {
                
                // MARK: Default user profile picture
                Image(systemName: "person.circle")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 60, height: 60)
                  .clipShape(Circle())
                  .foregroundColor(.gray)
                  .padding(5)
                
              }
            }
            Spacer()
          }
        }
      }
    }
}

struct TaskHousematesView_Previews: PreviewProvider {
    static var previews: some View {
        TaskHousematesView()
          .environmentObject(AuthViewModel.mock())
          .environmentObject(UserViewModel())
    }
}
