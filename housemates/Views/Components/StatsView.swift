//
//  StatsView.swift
//  housemates
//
//  Created by Bernard Sheng on 12/4/23.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userViewModel: UserViewModel
  
    let statHeight: CGFloat
    @State var barHeight = 0
  
  
    var body: some View {
      if let user = authViewModel.currentUser {
        
        if let group_id = user.group_id, let user_id = user.id {
          let maxVal = CGFloat(taskViewModel.getNumCompletedTasksForGroup(group_id))
          VStack {
            
            
            HStack(alignment: .bottom) {
              
              
              
              //            col(user: user, maxVal: maxVal)
              let groupMates = userViewModel.getUserGroupmatesInclusive(user_id)
              
              
              ForEach(groupMates) { mate in
                ZStack(alignment: .bottom) {
                  if let member_id = mate.id {
                    let barHeight: CGFloat = getBarHeight(member_id: member_id, maxVal: maxVal, statHeight: statHeight)
                    RoundedRectangle(cornerRadius: 5)
                      .frame(width: 35, height: barHeight)
                      .padding()
                    
                    let imageURL = URL(string: mate.imageURLString ?? "")
                    
                    AsyncImage(url: imageURL) { image in
                      image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    } placeholder: {
                      // Default user profile picture
                      Circle()
                        .fill(
                          LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.gray.opacity(0.4)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                          )
                        )
                        .frame(width: 50, height: 50)
                        .overlay(
                          Text("\(mate.first_name.prefix(1).capitalized + mate.last_name.prefix(1).capitalized)")
                          
                            .font(.custom("Nunito-Bold", size: 26))
                            .foregroundColor(.white)
                        )
                    }
                    
                    //                    .frame(height: getBarHeight(member_id: member_id, maxVal: maxVal, statHeight: statHeight))
                    //                    .frame(height: barHeight)
                    //                  VStack {
                    //                    Text("\(mate.first_name)")
                    //
                    //                  }
                    //                  .frame(height: barHeight)
                  }
                  
                  
                }
              }
            }
            .frame(height: statHeight)
            .padding()
            
            col(user: user, maxVal: maxVal)
            
            
          }
        }
        
        
      }
      
      
    }
  
  private func getBarHeight(member_id: String, maxVal: CGFloat, statHeight: CGFloat) -> CGFloat {
    return (CGFloat(taskViewModel.getNumCompletedTasksForUser(member_id)) / maxVal) * statHeight
    
  }
  private func col(user: User, maxVal: CGFloat) -> some View {
    VStack {
      
      if let user_id = user.id {
        
      
      let groupMates = userViewModel.getUserGroupmatesInclusive(user_id)
      
      
        ForEach(groupMates) { mate in
          HStack {
            
          
          
            if let member_id = mate.id {
              let imageURL = URL(string: mate.imageURLString ?? "")
              
              AsyncImage(url: imageURL) { image in
                image
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 50, height: 50)
                  .clipShape(Circle())
              } placeholder: {
//              default prof
                Circle()
                  .fill(
                    LinearGradient(
                      gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.gray.opacity(0.4)]),
                      startPoint: .topLeading,
                      endPoint: .bottomTrailing
                    )
                  )
                  .frame(width: 50, height: 50)
                  .overlay(
                    Text("\(mate.first_name.prefix(1).capitalized + mate.last_name.prefix(1).capitalized)")
                    
                      .font(.custom("Nunito-Bold", size: 26))
                      .foregroundColor(.white)
                  )
              }
              
              Text("\(taskViewModel.getNumCompletedTasksForUser(member_id))")
            }
              
            }
            
            
          }
        }
      }
      
      
      
      
    
    }
}

//struct StatsView_Previews: PreviewProvider {
//    static var previews: some View {
//      StatsView(statHeight: 10, maxVal: 20)
//    }
//}
