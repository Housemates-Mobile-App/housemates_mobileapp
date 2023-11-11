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
    @State private var progress = 0.0
    private let animationDuration = 1.0
    @State private var rotation: Double = 0
  
   
    
    var body: some View {
   
      if let user = authViewModel.currentUser {
        
        
        NavigationView {
          
          //            contains the task board
          VStack() {
            HStack {
              
              Text("Tasks")
                
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.purple)
              
              Spacer()
              
//              EditButton().padding(.horizontal).fontWeight(.semibold)
              Button(action: {
                self.progress += 0.25
              }) {
                Text("hi")
              }
              Button(action: {
                self.progress -= 0.25
              }) {
                Text("bye")
              }
              
              NavigationLink(destination: AddTaskView(user: user, taskViewModel: taskViewModel, hideTabBar: $hideTabBar, selectedTab: $selectedTab)) {
                Text("+")
                  .font(.title)
                  .padding(7.5)
                  .clipShape(Circle())
                  .fontWeight(.semibold)
                  .foregroundColor(Color.white)
                  .background(Circle().fill(Color.purple))
                    
                  
              }
            }
            .padding()
            
            
            
            //              allows for swiping
            TabView(selection: $selectedTab) {
              
              ScrollView {
                VStack(alignment: .leading) {
                  HStack {
                    Spacer()
                    Text(String(Int(self.progress) * 100) + "%")
                      .font(.title)
                      .bold()
                    Spacer()
                  }
                  
                  ZStack(alignment: .leading) {
                                  

                    Capsule() // Animated Foreground
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue, Color.purple]),
                                             startPoint: .leading, endPoint: .trailing))
                        .frame(width: CGFloat(self.progress) * UIScreen.main.bounds.width, height: 30)
                        .scaleEffect(y: 1 + CGFloat(self.progress) * 0.5, anchor: .leading)
                        .animation(.easeInOut(duration: animationDuration))
                    
                      Capsule() // Background
                          .frame(height: 30)
                          .foregroundColor(Color.gray.opacity(0.0))
                          .overlay(
                            Capsule().stroke(Color.black.opacity(0.25), lineWidth: 2)
                        )
                              }
                              .cornerRadius(15)
                              .padding()
                  
              
                  Text("Todo")
                    .font(.headline)
                    .padding(.top)
                    .bold()
                  
                  let unclaimedTasks = taskViewModel.getUnclaimedTasksForGroup(user.group_id!)
                  if unclaimedTasks.isEmpty {
                    MessageCardView(message: "All Tasks Complete")
                  }
                  ForEach(unclaimedTasks) { task in
                    TaskView(task: task, user: user)
                  }
                  
                  
                }
                .padding(.horizontal)
                
                // Recurring Tasks Section
                VStack(alignment: .leading) {
                  
                  Text("In Progress")
                    .font(.headline)
                    .padding(.top)
                   
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
                    .padding(.top)
                    .font(.headline)
                   
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
            
            
          }.background(
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.15), Color.purple.opacity(0.15)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                           .frame(maxWidth: .infinity, maxHeight: .infinity)
                           .edgesIgnoringSafeArea(.all))
          
          
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
