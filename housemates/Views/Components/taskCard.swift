//
//  taskCard.swift
//  housemates
//
//  Created by Daniel Gunawan on 12/4/23.
//

import SwiftUI

struct taskCard: View {
    @EnvironmentObject var userViewModel: UserViewModel
    var task: task
    var user: User
    
    var body: some View {
        VStack {
          
          
          
          if let uid = task.user_id {
            if let user = userViewModel.getUserByID(uid) {
              ZStack {
                Image(task.icon ?? "moon")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 65, height: 65)
                  
                  
    //              .overlay(Circle().stroke(Color.purple, lineWidth: 2))
                  .padding(7.5)
               
                  .background(Color(red: 0.439, green: 0.298, blue: 1.0))
                  .clipShape(Circle())
                  
                
                userProfileImage(for: user)
                  .offset(x: 35, y: 35)
              }
              Text(task.name)
                .font(.custom("Lato-Bold", size: 15))
              Text("Completed by \(user.first_name) \(user.last_name)")
                .font(.custom("Lato", size: 12))
                .foregroundColor(Color.gray)
                
            }
            
            
          }
          
        }
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 16)
            .stroke(Color(red: 0.439, green: 0.298, blue: 1.0), lineWidth: 3))
    }
    private func userProfileImage(for user: User) -> some View {
        AsyncImage(url: URL(string: user.imageURLString ?? "")) { image in
            image.resizable()
        } placeholder: {
            Image(systemName: "person.circle").resizable()
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: 35, height: 35)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 2))
        .padding(5)
    }
}

//#Preview {
//    taskCard()
//}
