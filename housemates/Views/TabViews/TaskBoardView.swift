//
//  TaskBoardView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI

struct TaskBoardView: View {
    @EnvironmentObject var taskViewModel : TaskViewModel
    @EnvironmentObject var authViewModel : AuthViewModel
    @State private var selectedTab = 0
    @Binding var hideTabBar: Bool
   
    
    var body: some View {
      if let user = authViewModel.currentUser {
        
        
        NavigationView {

//            contains the task board
            VStack() {
              HStack {
                Text("Task Board")
                  .font(.largeTitle)
                  .fontWeight(.bold)
                
                Spacer()
                
                EditButton().padding(.horizontal).fontWeight(.semibold)
                
                NavigationLink(destination: AddTaskView(user: user, taskViewModel: taskViewModel, hideTabBar: $hideTabBar, selectedTab: $selectedTab)) {
                  Text("+ Add")
                    .fontWeight(.semibold)
                }
              }
              .padding(.horizontal)
              .padding(.vertical)
              .background(.mint)
              .shadow(radius: 20)
              
//              allows for swiping
              TabView(selection: $selectedTab) {
                ScrollView {
                  VStack(alignment: .leading) {
                    Text("Todo")
                      .font(.title2)
                      .padding(.vertical)
                      .bold()
                    
                    let unclaimedTasks = taskViewModel.getUnclaimedTasksForGroup(user.group_id!)
                    if unclaimedTasks.isEmpty {
                      MessageCardView(message: "No Tasks To Do")
                    }
                    ForEach(unclaimedTasks) { task in
                      TaskView(task: task, user: user)
                    }
                    
                    
                  }
                  .padding(.horizontal)
                  
                  // Recurring Tasks Section
                  VStack(alignment: .leading) {
                    Text("In Progress")
                      .font(.title2)
                      .padding(.vertical)
                      .bold()
                    
                    let inProgressTasks = taskViewModel.getInProgressTasksForGroup(user.group_id!)
                    if inProgressTasks.isEmpty {
                      MessageCardView(message: "No Tasks in Progress")
                    }
                    ForEach(inProgressTasks) { task in
                      TaskView(task: task, user: user)
                    }
                    
                  }
                  .padding(.horizontal)
                  
                  VStack(alignment: .leading) {
                    Text("Completed")
                      .font(.title2)
                      .padding(.vertical)
                      .bold()
                    
                    let completedTasks = taskViewModel.getCompletedTasksForGroup(user.group_id!)
                    if completedTasks.isEmpty {
                      MessageCardView(message: "No Completed Tasks")
                    }
                    ForEach(completedTasks) { task in
                      TaskView(task: task, user: user)
                    }
                  }
                  .tag(0)
                  .padding(.horizontal)
                }
                  
                GraphView()
                    .tag(1)
               
              
              
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
              Spacer()
            
            
          }
          
          
          
          
        }
      }
    }
}


struct TaskBoardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskBoardView(hideTabBar: Binding.constant(false))
            .environmentObject(AuthViewModel.mock())
            .environmentObject(TaskViewModel())
            .environmentObject(UserViewModel())
    }
    
}
