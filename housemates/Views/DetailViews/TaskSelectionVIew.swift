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
                // Top part with a different background color
                Color(red: 0.439, green: 0.298, blue: 1.0)
                    .frame(width: 400, height: 120)
                    .overlay(
                        Text("Add Task")
                            .font(.system(size: 18))
                            .bold()
                            .foregroundColor(.white)
                            .padding(.top, 70)
                            .padding(.trailing, 250)
                )
                
                // Search bar placeholder
                TextField("Search for a template...", text: .constant(""))
                    .font(.system(size: 20))
                    .padding(13)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .frame(width: 370)
                
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15) {
                            HStack {
                                AnimatedImage(name: "trashAnimated.gif", isAnimating: $isAnimating).frame(width: 50, height: 50)
                                AnimatedImage(name: "trashAnimated.gif", isAnimating: $isAnimating).frame(width: 50, height: 50)
                                AnimatedImage(name: "trashAnimated.gif", isAnimating: $isAnimating).frame(width: 50, height: 50)
                                AnimatedImage(name: "trashAnimated.gif", isAnimating: $isAnimating).frame(width: 50, height: 50)
                                AnimatedImage(name: "trashAnimated.gif", isAnimating: $isAnimating).frame(width: 50, height: 50)
                            }
                            Text("Housework")
                                .font(.system(size: 12))
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
                                .font(.system(size: 12))
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
                                .font(.system(size: 12))
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
                    .padding(.bottom, 20)
                    .padding(.horizontal, 15)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(red: 0.8118, green: 0.8196, blue: 1.0))
                        .padding(.bottom, 40)
                )

            }
            // Oval-shaped button at the bottom
            VStack {
                Spacer()
                NavigationLink(destination:
                                AddTaskView(taskIconStringHardcoded: "", taskNameHardcoded: "", user: user, hideTabBar: $hideTabBar, selectedTab: $selectedTab)) {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(red: 0.439, green: 0.298, blue: 1.0))
                        .frame(width: 222, height: 51)
                        .overlay(
                            Text("Add a Custom Task +")
                                .font(.system(size: 18))
                                .bold()
                                .foregroundColor(.white)
                            
                        )
                        .offset(y:-20)
                }
            }
        }
        .onAppear {
            //setting taskName to be the input
            hideTabBar = true
        }
        .onDisappear {
            hideTabBar = false
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 0.925, green: 0.863, blue: 1.0).opacity(0.25),
                Color(red: 0.619, green: 0.325, blue: 1.0).opacity(0.25)
            ]), startPoint: .top, endPoint: .bottom)
            ).ignoresSafeArea(.all)
    }
}

struct TaskSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TaskSelectionView(user: UserViewModel.mockUser(), hideTabBar: Binding.constant(false), selectedTab: Binding.constant(2)).environmentObject(TaskViewModel())
    }
}
