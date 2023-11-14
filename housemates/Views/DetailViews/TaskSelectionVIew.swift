//
//  TaskSelectionVIew.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/10/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct TaskSelectionView: View {
    @EnvironmentObject var taskViewModel : TaskViewModel
    let user : User
    @Binding var hideTabBar: Bool
//  added this to bring the user back to the first page after adding a task
    @Binding var selectedTab: Int
    @State var isAnimating : Bool = true
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
              Text("Select Task")
                .font(.title)
                .fontWeight(.bold)
                
                // Top part with a different background color
                
                
                // Search bar placeholder
              HStack {
                  Image(systemName: "magnifyingglass")
                      .foregroundColor(.gray) // Icon color
                      .padding(5)

                  TextField("What task do you want to add?", text: .constant(""))
                      .font(.system(size: 14))
                      .foregroundColor(Color.black) // Text color
                      .padding(.vertical, 10)
                      .background(Color.clear) // Clear background for the text field
              }
              .padding(.horizontal, 10) // Horizontal padding for the HStack
              .background(Color(.systemGray5)) // Slightly gray background for the entire HStack
              .cornerRadius(15)
              .padding(.horizontal)// Corner radius of 15
             // Fixed width for the HStack

                
                
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15) {
                            Text("Housework")
                                .font(.system(size: 14))
                                .bold()
                            ForEach(0..<hardcodedHouseworkTaskData.count, id: \.self) { i in
                                if i % 3 == 0 {
                                    HStack {
                                        ForEach(0..<min(3, hardcodedHouseworkTaskData.count - i), id: \.self) { j in
                                            NavigationLink(destination:
                                                            AddTaskView(taskIconStringHardcoded: hardcodedHouseworkTaskData[i + j].taskIcon, taskNameHardcoded: hardcodedHouseworkTaskData[i + j].taskName, user: user, hideTabBar: $hideTabBar, selectedTab: $selectedTab)) {
                                                TaskSelectionBox(taskIconString: hardcodedHouseworkTaskData[i + j].taskIcon, taskName: hardcodedHouseworkTaskData[i + j].taskName)
                                            }
                                        }
                                    }
                                }
                            }
                          
                            Text("Indoor")
                                .font(.system(size: 14))
                                .bold()
                            ForEach(0..<hardcodedIndoorTaskData.count, id: \.self) { i in
                                if i % 3 == 0 {
                                    HStack {
                                        ForEach(0..<min(3, hardcodedIndoorTaskData.count - i), id: \.self) { j in
                                            NavigationLink(destination:
                                                            AddTaskView(taskIconStringHardcoded: hardcodedIndoorTaskData[i + j].taskIcon, taskNameHardcoded: hardcodedIndoorTaskData[i + j].taskName, user: user, hideTabBar: $hideTabBar, selectedTab: $selectedTab)) {
                                                TaskSelectionBox(taskIconString: hardcodedIndoorTaskData[i + j].taskIcon, taskName: hardcodedIndoorTaskData[i + j].taskName)
                                            }
                                        }
                                    }
                                }
                            }
                            Text("Outdoor")
                                .font(.system(size: 14))
                                .bold()
                            ForEach(0..<hardcodedOutdoorTaskData.count, id: \.self) { i in
                                if i % 3 == 0 {
                                    HStack {
                                        ForEach(0..<min(3, hardcodedOutdoorTaskData.count - i), id: \.self) { j in
                                            NavigationLink(destination:
                                                            AddTaskView(taskIconStringHardcoded: hardcodedOutdoorTaskData[i + j].taskIcon, taskNameHardcoded: hardcodedOutdoorTaskData[i + j].taskName, user: user, hideTabBar: $hideTabBar, selectedTab: $selectedTab)) {
                                                TaskSelectionBox(taskIconString: hardcodedOutdoorTaskData[i + j].taskIcon, taskName: hardcodedOutdoorTaskData[i + j].taskName)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }.padding()
                    // bad style. double padding can we fix this. hardcoded.
                    
                

            }
            // Oval-shaped button at the bottom
          VStack {
              Spacer()
              NavigationLink(destination: AddTaskView(taskIconStringHardcoded: "", taskNameHardcoded: "", user: user, hideTabBar: $hideTabBar, selectedTab: $selectedTab)) {
                  Text("Add a Custom Task +")
                      .font(.system(size: 18))
                      .bold()
                      .foregroundColor(.white)
                      .frame(maxWidth: .infinity, minHeight: 50)
                      .background(Color(red: 0.439, green: 0.298, blue: 1.0))
                      .cornerRadius(30)
                      .padding(.horizontal)
              }
              .buttonStyle(PlainButtonStyle())
              .offset(y: -20) // If needed to offset the button upwards
          }
          

        }
        .onAppear {
            //setting taskName to be the input
            hideTabBar = true
        }
        .onDisappear {
            hideTabBar = false
        }
        
    }
}

struct TaskSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TaskSelectionView(user: UserViewModel.mockUser(), hideTabBar: Binding.constant(false), selectedTab: Binding.constant(2)).environmentObject(TaskViewModel())
    }
}
