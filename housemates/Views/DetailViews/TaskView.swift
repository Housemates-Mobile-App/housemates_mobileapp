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
    @Binding var progress: Double
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
                          Text("\(user.first_name) \(user.last_name) completed this task").font(.subheadline)
                      }
                  }
              }
              
              else {
                
                switch (task.priority) {
                case "Low":
                  Text(task.priority)
                    .font(.subheadline)
                    .foregroundColor(Color.green)
                case "Medium":
                  Text(task.priority)
                    .font(.subheadline)
                    .foregroundColor(Color.orange)
                
                default:
                  Text(task.priority)
                    .font(.subheadline)
                    .foregroundColor(Color.red)
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
                  .bold()
                  
                  .font(.system(size: 12))
                  .foregroundColor(.white)
                  .padding(.horizontal)
                  .padding(.vertical, 4)
                  .background(Color.red)
                  .cornerRadius(15)
              }
            }

            // MARK: Display appropriate button
            switch task.status {
                case .done:
                    Label("Done", systemImage: "checkmark.circle.fill")
                        .labelStyle(.iconOnly)
                        .foregroundColor(.green)
                  
                case .inProgress:
                      if taskViewModel.isMyTask(task: task, user_id: user.id ?? "") {
                        Button(action: {
                          taskViewModel.completeTask(task: task)
                          progress += 0.25
                        }) {
                          Text("Done")
                            .bold()
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .background(Color.green)
                            .cornerRadius(15)
                        }
                      } else {
                        
//                        if let uid = task.user_id {
//                            if let user = userViewModel.getUserByID(uid) {
//                                Text("Assigned To: \(user.first_name) \(user.last_name)").font(.subheadline)
//                            }
//                        }
                        let imageURL = URL(string: user.imageURLString ?? "")
                        
                        
//                        puts the user who claimed the task next to task instead of who it was claimed by
                        if let uid = task.user_id {
                          if let user = userViewModel.getUserByID(uid) {
                            let imageURL = URL(string: user.imageURLString ?? "")
                            AsyncImage(url: imageURL) {
                              image in image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
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
                                  .frame(width: 35, height: 35)
                                  .clipShape(Circle())
                                  .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                  .shadow(radius: 5)
                                  .foregroundColor(.gray)
                                  .padding(5)
                              
                          }
                           
                          }
                        }
                        
                        
                       
//
//                        Label("In Progress", systemImage: "timer")
//                            .labelStyle(.iconOnly)
//                            .foregroundColor(.blue)
//                            .textCase(.uppercase)
                      }
                    
                case .unclaimed:
                    Button(action: {
                        if let uid = user.id {
                            taskViewModel.claimTask(task: task, user_id: uid)
                        }
                    }) {
                        Text("Claim")
                            .bold()
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                          
                            .background((Color(red: 0.439, green: 0.298, blue: 1.0)))
                            .cornerRadius(15)
                    }
                }
        }
        
        .padding(15)
        
        .background(
            RoundedRectangle(cornerRadius: 15)
              .fill(Color.white.opacity(0.95)) // Adds a white fill
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
              .stroke(Color.black.opacity(0.25), lineWidth: 1) // Adds a black stroke
        )
        
        
       
        
        
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
      TaskView(task: TaskViewModel.mockTask(), user: UserViewModel.mockUser(), progress: Binding.constant(20.0)).environmentObject(UserViewModel())
    }
}

