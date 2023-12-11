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
    @State private var showDropdown: Bool = false
    @State private var selectedGraph: String = "All Time"
    @State private var selectedUser: String? = nil
    @State private var animation: Bool = false
    
  
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    let lightPurple = Color(red: 0.725, green: 0.631, blue: 1.0)

    var body: some View {
        if let user = authViewModel.currentUser {
            
            if let group_id = user.group_id, let user_id = user.id {
                let maxVal = CGFloat(taskViewModel.getCompletedTasksForGroupByDay(group_id, timeframe: selectedGraph).count)
                ZStack(alignment: .bottom) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack() {
                            
                            HStack {
                                
                                
                                
                                VStack {
                                    
                                    Text("Tasks Completed")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.custom("Nunito-Bold", size: 16))
                                    Text(selectedGraph)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.custom("Lato", size: 12))
                                }
                                Spacer()
                                GraphFilterView(selected: $selectedGraph, showDropdown: $showDropdown)
                                    .zIndex(1)
                            }.padding()
                            
                            
                            
                            
                            VStack(alignment: .leading, spacing: 15) {
                                
                                
                                //            col(user: user, maxVal: maxVal)
                                let groupMates = userViewModel.getUserGroupmatesInclusiveByTaskTime(user_id, taskViewModel, timeframe: selectedGraph)
                                
                                
                                
                                ForEach(groupMates) { mate in
                                    GraphForUser(mate: mate, maxVal: maxVal, groupMates: groupMates)
                                }
                                
                            }
                            
                            //             CREATES THE ENTIRE BOX
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .overlay(RoundedRectangle(cornerRadius: 15)
                                .stroke(deepPurple, lineWidth: 2))
                            //              .frame(height: statHeight)
                            
                            .padding(.horizontal)
                            
                            .overlay(
                                // Dropdown as an overlay
                                SwiftUI.Group {
                                    if showDropdown {
                                        VStack {
                                            
                                            
                                            HStack {
                                                
                                                
                                                Spacer()
                                                GraphFilterView(selected: $selectedGraph, showDropdown: $showDropdown)
                                                    .dropdownOptions()
                                                // Adjust positioning as needed
                                                    .offset(x: 0, y: -10)
                                                    .zIndex(2)
                                                
                                            }
                                            Spacer()
                                        }.padding(.horizontal)
                                    }
                                }
                            )
                            //              .onChange(of: selectedGraph) { _ in
                            //                updateFilteredTasks(user_id: user_id)
                            //
                            //              }
                            
                            //            .border(.bottom, width: 3, color: lightPurple)
                            
                            
                            
                            //            col(user: user, maxVal: maxVal)
                            //             HStack {
                            //               RoundedRectangle(cornerRadius: 5)
                            //                 .frame(height: 3)
                            //                 .foregroundColor(lightPurple)
                            //             }.frame(maxWidth: .infinity)
                            //             creates the box around
                            VStack {
                                
                                if let selected = selectedUser {
                                    if let user = userViewModel.getUserByID(selected) {
                                        Text("\(user.first_name)'s Completed Tasks")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.custom("Nunito-Bold", size: 15))
                                        Text("\(selectedGraph) • \(getPercentageForUser(member_id: selected, maxVal: maxVal))%")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.custom("Lato", size: 12))
                                        
                                        
                                    }
                                }
                                else {
                                    Text("Select to See Completed Tasks")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.custom("Nunito-Bold", size: 15))
                                }
                            }.padding()
                            
                            completedTasks()
                                .padding(.horizontal)
                                .padding(.bottom, 40)
                            //             add to  vstack here the completed
                        }
                        
                    }
                }
                
                
            }
        }
      
    }
  
  
  private func GraphForUser(mate: User, maxVal: CGFloat, groupMates: [User]) -> some View{
  
    HStack() {
      if let member_id = mate.id, let first_id = groupMates[0].id {
        
        let imageURL = URL(string: mate.imageURLString ?? "")
        
        
        ZStack() {
          
          
          Button(action: {
            self.selectedUser = member_id
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
              withAnimation {
                self.selectedUser = member_id
                
              }
            }
            
            
          }) {
            AsyncImage(url: imageURL) { image in
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(Circle().stroke(first_id == member_id ? .yellow : (self.selectedUser == member_id ? deepPurple : .clear), lineWidth: 2))
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
                .frame(width: 40, height: 40)
                .overlay(
                  Text("\(mate.first_name.prefix(1).capitalized + mate.last_name.prefix(1).capitalized)")
                  
                    .font(.custom("Nunito-Bold", size: 18))
                    .foregroundColor(.white)
                )
                .overlay(Circle().stroke(self.selectedUser == member_id ? deepPurple : .clear, lineWidth: 3))
            }.padding(.horizontal)
          }
          
          Image("crown")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 35, height: 35)
            .opacity(first_id == member_id ? 100 : 0)
            .offset(x: 0, y:-32.5)
            .padding(.top, first_id == member_id ? 20 : 0)
          
          
        }
   
          
          let numTasks: [task] = getNumTasks(member_id: member_id)
          
          
          if numTasks.count != 0 {
            
            
            let barHeight: CGFloat = getBarHeight(member_id: member_id, maxVal: maxVal, statHeight: statHeight)
            
            //                    creates the bar on the graph
            Button(action: {
              self.selectedUser = member_id
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                      withAnimation {
                          self.selectedUser = member_id
                          
                      }
                  }
              
              
            }) {
             
                
                
//                          MAKES THE BAR AND ALSO MAKES IT SO THE END IS STRAIGHT
                
              
              RoundedRectangle(cornerRadius: 5)
// bar height actually means bar width
                .frame(width: barHeight, height: 32.5)
                .foregroundColor(deepPurple.opacity(calculateOpacity(mateIndex: CGFloat(userViewModel.getGroupmateIndex(member_id, in: groupMates) ?? 0))))

                
              
              
              
//                            Rectangle()
//                              .foregroundColor(animation ? .white : deepPurple)
//                              .frame(width: barHeight / 2, height: 32.5)
//
//
                .padding(.vertical, 3.5)
              
            }
            
            
            
            
            //                        .overlay(RoundedRectangle(cornerRadius: 5)
            //                          .stroke(lightPurple, lineWidth: 2))
            //                        .padding(.horizontal)
            
           
            
            
            
          }
          
        
        
        
        
        
        Text("\(numTasks.count)")
          .font(.custom("Lato-Bold", size: 16))
          .foregroundColor(deepPurple)
          .padding(.trailing)
        
        
        
        
        //                    .frame(height: getBarHeight(member_id: member_id, maxVal: maxVal, statHeight: statHeight))
        //                    .frame(height: barHeight)
        //                  VStack {
        //                    Text("\(mate.first_name)")
        //
        //                  }
        //                  .frame(height: barHeight)
      }
      
    
     
      
    Spacer()
    }
  }
  
  
  private func completedTasks() -> some View {
      VStack {
          if let user_id = selectedUser {
              completedTasksView(for: user_id)
          }
      }
  }

  private func completedTasksView(for userId: String) -> some View {
      let tasks = taskViewModel.getCompletedTasksForUserByDay(userId, timeframe: selectedGraph)

      return ScrollView(.horizontal, showsIndicators: false) {
          HStack {
              ForEach(tasks) { task in
                  if let user = userViewModel.getUserByID(userId) {
                    
                    NavigationLink(destination: TaskDetailView(currUser: user, currTask:task)) {
                        taskCard(task: task, user: user)
                    }
                    
                  }
              }
          }
      }
  }


  
  private func calculateOpacity(mateIndex: CGFloat) -> Double {
    let minOpacity: CGFloat = 0.2
    let increment: CGFloat = 0.25
    return max(minOpacity, 1.0 - (increment * mateIndex))
  }
  
  private func getNumTasks(member_id: String) -> [task] {
    
    return taskViewModel.getCompletedTasksForUserByDay(member_id, timeframe: selectedGraph)
  }
  
  private func getBarHeight(member_id: String, maxVal: CGFloat, statHeight: CGFloat) -> CGFloat {
    return (CGFloat(taskViewModel.getCompletedTasksForUserByDay(member_id, timeframe: selectedGraph).count) / maxVal) * statHeight
    
  }
  
  private func getPercentageForUser(member_id: String, maxVal: CGFloat) -> Int {
    let num: Int = taskViewModel.getCompletedTasksForUserByDay(member_id, timeframe: selectedGraph).count
    let percent: CGFloat = CGFloat(num) / CGFloat(maxVal)
    return Int(percent * 100)
    
  }
  

}



//struct StatsView_Previews: PreviewProvider {
//    static var previews: some View {
//       
//        return StatsView(statHeight: 300)
//            .environmentObject(mockTaskViewModel)
//            .environmentObject(mockAuthViewModel)
//            .environmentObject(mockUserViewModel)
//    }
//}



