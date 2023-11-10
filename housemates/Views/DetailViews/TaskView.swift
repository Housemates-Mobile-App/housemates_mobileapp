//
//  TaskView.swift
//  housemates
//
//  Created by Bernard Sheng on 11/2/23.
//

import SwiftUI

struct TaskView: View {
    let task: task
    let user: User
    @EnvironmentObject var taskViewModel : TaskViewModel
    @EnvironmentObject var authViewModel : AuthViewModel    
    @EnvironmentObject var userViewModel : UserViewModel

    @Environment(\.editMode) private var editMode
    
    var body: some View {
        HStack {
            // MARK: Display Task information
            VStack(alignment: .leading) {
                Text(task.name)
                    .font(.headline)
               
              if task.status == .done {
                Text(task.date_completed ?? "BUG ?")
                  if let uid = task.user_id {
                      if let user = userViewModel.getUserByID(uid) {
                          Text("Completed By: \(user.first_name) \(user.last_name)").font(.subheadline)
                      }
                  }
              }
              
              else {
                Text("Priority: " + task.priority).font(.subheadline)
                  if let uid = task.user_id {
                      if let user = userViewModel.getUserByID(uid) {
                          Text("Assigned To: \(user.first_name) \(user.last_name)").font(.subheadline)
                      } 
                  }
              }
            }
            Spacer()
          
          // MARK: Get editMode status.  If active show delete button
          if editMode?.wrappedValue == .active {
              Button(action: {
                taskViewModel.destroy(task: task)
              }) {
                Text("Delete")
                  .foregroundColor(.white)
                  .padding(.horizontal)
                  .padding(.vertical, 4)
                  .background(Color.red)
                  .cornerRadius(8)
              }
            }

            // MARK: Display appropriate button
            switch task.status {
                case .done:
                    Label("DONE", systemImage: "checkmark.circle.fill")
                        .labelStyle(.iconOnly)
                        .foregroundColor(.green)
                  
                case .inProgress:
                      if taskViewModel.isMyTask(task: task, user_id: user.id ?? "") {
                        Button(action: {
                          taskViewModel.completeTask(task: task)
                        }) {
                          Text("DONE")
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .cornerRadius(8)
                        }
                      } else {
                        Label("IN PROGRESS", systemImage: "timer")
                            .labelStyle(.iconOnly)
                            .foregroundColor(.blue)
                            .textCase(.uppercase)
                      }
                    
                case .unclaimed:
                    Button(action: {
                        if let uid = user.id {
                            taskViewModel.claimTask(task: task, user_id: uid)
                        }
                    }) {
                        Text("CLAIM")
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .mint, radius: 4)
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: TaskViewModel.mockTask(), user: UserViewModel.mockUser()).environmentObject(UserViewModel())
    }
}

