//
//  HousemateProfileView.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/2/23.
//

import SwiftUI
import CachedAsyncImage

struct HousemateProfileView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var taskViewModel : TaskViewModel
    @EnvironmentObject var tabBarViewModel : TabBarViewModel
    @EnvironmentObject var friendInfoViewModel : FriendInfoViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let housemate: User
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    var body: some View {
        let recentTasks = taskViewModel.getRecentCompletedTasksForUser(housemate.id ?? "")
        let imageSize = UIScreen.main.bounds.width * 0.25
        let componentOffset = UIScreen.main.bounds.height * 0.063
        
        ZStack {
            
            // MARK: Wave Background
            VStack {
                ZStack {
                    NewWave()
                        .fill(deepPurple)
                        .frame(height: UIScreen.main.bounds.height * 0.20)
                    
                    let imageURL = URL(string: housemate.imageURLString ?? "")
                    
                    CachedAsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageSize, height: imageSize)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .offset(y: UIScreen.main.bounds.height * 0.10)
                    } placeholder: {
                        // Default user profile picture
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(red: 0.6, green: 0.6, blue: 0.6), Color(red: 0.8, green: 0.8, blue: 0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: imageSize, height: imageSize)
                            .overlay(
                                Text("\(housemate.first_name.prefix(1).capitalized + housemate.last_name.prefix(1).capitalized)")
                                
                                    .font(.custom("Nunito-Bold", size: 40))
                                    .foregroundColor(.white)
                            )
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .offset(y: UIScreen.main.bounds.height * 0.10)
                    }
                }
                // MARK: Housemate name
                Text("\(housemate.first_name) \(housemate.last_name)")
                    .font(.system(size: 26))
                    .bold()
                    .foregroundColor(.black)
                    .offset(y: componentOffset)
                
                // MARK: Hosuemate buttons
                HStack(spacing: 15) {
                    HousemateProfileButton(phoneNumber: housemate.phone_number, title: "Call", iconStr: "phone.fill", urlScheme:"tel")
                    HousemateProfileButton(phoneNumber: housemate.phone_number, title: "Text", iconStr: "message.fill", urlScheme:"sms")
                }.offset(y: componentOffset * 0.95)
                
                // MARK: Task Card
                HStack(spacing: 45) {
                    VStack {
                        Text("\(taskViewModel.getNumCompletedTasksForUser(housemate.id!))")
                            .font(.system(size: 32))
                            .foregroundColor(deepPurple)
                            .bold()
                        Text("Completed")
                            .font(.custom("Lato", size: 15))
                            .frame(minWidth: 55)
                    }
                    .padding(.leading, 50)
                    .padding(.vertical, 25)
                    VStack {
                        Text("\(taskViewModel.getNumPendingTasksForUser(housemate.id!))")
                            .foregroundColor(deepPurple)
                            .font(.system(size: 32))
                            .bold()
                        Text("Pending")
                            .font(.custom("Lato", size: 15))
                            .frame(minWidth: 55)
                    }
                    .padding(.trailing, 50)
                    .padding(.vertical, 25)
                }.background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                ).offset(y: componentOffset * 1.15)
                
                VStack(spacing: 10){
                    HStack {
                        Text("Recent Activity")
                            .font(.custom("Nunito-Bold", size: 22))
                            .bold()
                        Spacer()
                    }
                    
                    if (!recentTasks.isEmpty) {
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack {
                                ForEach(recentTasks) {task in
                                    NavigationLink(destination: TaskDetailView(currUser: housemate, currTask:task)) {
                                        
                                        taskCard(task: task, user: housemate)
                                    }
                                }
                            }
                        }
                    } else {
                        Text("There's no recent activity...")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom("Lato", size: 15))
                      
                    }
                }.offset(y: componentOffset * 1.30)
                 .padding(.leading, 35)
                
                Spacer()
            }.edgesIgnoringSafeArea(.top)
    }.navigationBarBackButtonHidden(true)
     .navigationBarItems(leading: backButton())
     .onAppear {
         tabBarViewModel.hideTabBar = true
    }
}
    private func backButton() -> some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .font(.system(size:18))
                    .bold()
                    .padding(.vertical)
            }
        }
    }

}

struct HousemateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        HousemateProfileView(housemate: UserViewModel.mockUser())
            .environmentObject(AuthViewModel())
            .environmentObject(TaskViewModel())
            .environmentObject(TabBarViewModel())
            .environmentObject(FriendInfoViewModel())
    }
}

// MARK: Recent Activity

