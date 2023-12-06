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
              ZStack(alignment: .bottomTrailing) {
                Image(task.icon ?? "moon")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 65, height: 65)
                  
                  
    //              .overlay(Circle().stroke(Color.purple, lineWidth: 2))
                  .padding(7.5)
               
                  .background(Color(red: 0.439, green: 0.298, blue: 1.0))
                  .clipShape(Circle())
                  
                
                userProfileImage(for: user)
                  .offset(x: 10, y: 10)
             
              }
              Text(task.name)
                .font(.custom("Lato-Bold", size: 15))
              Text("\(user.first_name) \(user.last_name)")
                .font(.custom("Lato", size: 12))
                .foregroundColor(Color.gray)
                
            }
            
            
          }
          
        }
        .padding()
        .frame(minWidth: 150)
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(Color(red: 0.439, green: 0.298, blue: 1.0), lineWidth: 2))
        .padding(2)
        
       
    }
    private func userProfileImage(for user: User) -> some View {
        AsyncImage(url: URL(string: user.imageURLString ?? "")) { image in
            image.resizable()
        } placeholder: {
          Circle()
              .fill(
                  LinearGradient(
                      gradient: Gradient(colors: [Color(red: 0.6, green: 0.6, blue: 0.6), Color(red: 0.8, green: 0.8, blue: 0.8)]),
                      startPoint: .topLeading,
                      endPoint: .bottomTrailing
                  )
              )
              .frame(width: 100, height: 100)
              .overlay(
                  Text("\(user.first_name.prefix(1).capitalized + user.last_name.prefix(1).capitalized)")
                  
                      .font(.custom("Nunito-Bold", size: 15))
                      .foregroundColor(.white)
              )
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: 30, height: 30)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 2))
        .padding(5)
    }
}

//#Preview {
//    taskCard()
//}
