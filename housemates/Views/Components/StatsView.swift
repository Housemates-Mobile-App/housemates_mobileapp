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
  
    let statHeight: Int
    let maxVal: Int
    var body: some View {
      if let user = authViewModel.currentUser {
        HStack {
          
          
          Text("Hi")
          col(user: user)
        }
        
      }
      
      
    }
  
  private func col(user: User) -> some View {
    VStack {
      
      
      if let user_id = user.id {
        let rows = userViewModel.getGroupCount(user_id)
        
        Text("\(rows)")
        
        
      }
      
      
      
      
    }
    }
}

//struct StatsView_Previews: PreviewProvider {
//    static var previews: some View {
//      StatsView(statHeight: 10, maxVal: 20)
//    }
//}
