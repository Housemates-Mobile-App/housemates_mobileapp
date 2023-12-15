//
//  ProfileView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI
import PhotosUI
import CachedAsyncImage

enum ActiveAlert: Identifiable {
    case leaveGroup, signOut

    var id: Int {
        switch self {
        case .leaveGroup:
            return 1
        case .signOut:
            return 2
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var groupViewModel: GroupViewModel
//    @EnvironmentObject var postViewModel: PostViewModel
    @EnvironmentObject var tabBarViewModel: TabBarViewModel
    @State private var group: Group?
    @State private var group_code: String?
    @State private var group_name: String?
    @State private var selectedPhoto:  PhotosPickerItem?
    @State private var uiImageSelected = UIImage()
    @State private var activeAlert: ActiveAlert?

    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    
    var body: some View {
        let imageSize = UIScreen.main.bounds.width * 0.25
        let componentOffset = UIScreen.main.bounds.height * 0.063
        if let user = authViewModel.currentUser {
            NavigationStack {
                ZStack(alignment: .topLeading) {
                   
                        
                    VStack {
                        ZStack {
                            // MARK: Wave Background
                            NewWave()
                                .fill(deepPurple)
                                .frame(height: UIScreen.main.bounds.height * 0.13)
                        }
                        
                        // MARK: Profile Picture
                        let imageURL = URL(string: user.imageURLString ?? "")
                        
                        CachedAsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: imageSize, height: imageSize)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .offset(x: -UIScreen.main.bounds.width * 0.32 ,y: UIScreen.main.bounds.height * -0.018)
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
                                    Text("\(user.first_name.prefix(1).capitalized + user.last_name.prefix(1).capitalized)")
                                    
                                        .font(.custom("Nunito-Bold", size: 40))
                                        .foregroundColor(.white)
                                )
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .offset(x: -UIScreen.main.bounds.width * 0.32 ,y: UIScreen.main.bounds.height * -0.018)
                        }
                            
                        // MARK: Photo picker for changing profile picture
                        PhotosPicker(selection: $selectedPhoto,
                                     matching: .images) {
                            Image(systemName: "camera.circle.fill")
                                .symbolRenderingMode(.multicolor)
                                .font(.system(size: 24))
                                .foregroundColor(.accentColor)
                        }.onChange(of: selectedPhoto) { newValue in
                            Task {
                                do {
                                    if let data = try await newValue?.loadTransferable(type: Data.self) {
                                        if let uiImage = UIImage(data: data) {
                                            uiImageSelected = uiImage
                                            _ = await authViewModel.saveProfilePicture(image: uiImageSelected)
                                        }
                                    }
                                } catch {
                                    print("ERROR: Selecting image failed \(error.localizedDescription)")
                                }
                            }
                        }.offset(x: -UIScreen.main.bounds.width * 0.22, y: UIScreen.main.bounds.height * -0.06)
                      
                        // MARK: Task Card
                        HStack(spacing: 17) {
                            VStack {
                                Text("Completed")
                                    .font(.custom("Nunito", size: 15))
                                    .frame(minWidth: 55)
                                Text("\(taskViewModel.getNumCompletedTasksForUser(user.user_id))")
                                    .font(.system(size: 32))
                                    .foregroundColor(deepPurple)
                                    .bold()
                                
                            }
                            
                            Divider().frame(height: UIScreen.main.bounds.height * 0.07)
                            
                            VStack {
                                Text("Pending")
                                    .font(.custom("Nunito", size: 15))
                                    .frame(minWidth: 55)
                                Text("\(taskViewModel.getNumPendingTasksForUser(user.user_id))")
                                    .foregroundColor(deepPurple)
                                    .font(.system(size: 32))
                                    .bold()
                               
                            }
                           
                        }.offset(x: UIScreen.main.bounds.width * 0.16, y: -componentOffset * 2.2)
                       
                        Spacer()
                    }.edgesIgnoringSafeArea(.top)
                    // MARK: End Vstack
                
                
                    // MARK: Housemate name
                    VStack(alignment: .leading) { // Set alignment to .leading
                 
                        Text("\(user.first_name) \(user.last_name)")
                            .font(.custom("Nunito-Bold", size: 26))
                            .bold()
                         
                        

                        if let group_name = group_name {
                            Text(group_name)
                                .font(.custom("Nunito-Bold", size: 16))
                                .foregroundColor(deepPurple)
                        } else {
                            Text("Group Name: N/A")
                                .font(.custom("Nunito-Bold", size: 16))
                                .foregroundColor(deepPurple)
                        }
                    }.offset(y: UIScreen.main.bounds.height * 0.178)
                        .padding(.leading, 27)
                    
                    
                     let recentTasks = taskViewModel.getRecentCompletedTasksForUser(user.user_id)

                     
                // MARK: Calendar Preview
                VStack {
                    if (!recentTasks.isEmpty) {

                        ScrollView(.horizontal, showsIndicators: false) {

                            HStack(spacing: 15){
                                ForEach(recentTasks) {task in
                                    NavigationLink(destination: TaskDetailView(currUser: user, currTask:task)) {

                                        taskCard(task: task, user: user)
                                    }
                                }
                            }
                        }
                    }

                    HStack {
                        Text("Your Activity")
                            .font(.custom("Nunito-Bold", size: 21))
                            .bold()
                        Spacer()
                    }
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 16)
                        //                                .foregroundColor(deepPurple.opacity(0.6))
                            .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                            .frame(width: UIScreen.main.bounds.width * 0.90,
                                   height: UIScreen.main.bounds.height * 0.23)

                        Text("Last 14 Days").padding()
                            .font(.custom("Nunito-Bold", size: 17))
                            .foregroundColor(.black)
                            .offset(y: -4)

                        // cells for two weeks ago
                        HStack(spacing: 5) {
                            ForEach((0..<7).reversed(), id: \.self) { dayIndex in
                                SmallSquare(dayOffset: dayIndex + 7, user: user)

                            }
                        }
                        .offset(x: componentOffset * 0.2, y: componentOffset * 0.80)

                        // cells for one week ago
                        HStack(spacing: 5) {
                            ForEach((0..<7).reversed(), id: \.self) { dayIndex in
                                SmallSquare(dayOffset: dayIndex, user: user)
                            }
                        }
                        .offset(x: componentOffset * 0.2, y: componentOffset * 2)

                        // View all activity button
                        NavigationLink(destination: CalendarView( user: user)) {

                            Text("View All")
                                .font(.custom("Lato-Bold", size: 16))
                                .foregroundColor(.black)
                                .padding(.all, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                        }.offset(x: UIScreen.main.bounds.width * 0.68, y: UIScreen.main.bounds.height * 0.011)



                    }.offset(x: -UIScreen.main.bounds.width * 0.03,
                             y: -UIScreen.main.bounds.height * 0.015)


                }.offset(y: componentOffset * 4.2)
                .padding(.leading, 20)

                // MARK: END Calendar  Preview
                
                
                // MARK: Menu for Prolile Tab
                    HStack {
                        Spacer()
                        Menu {
                            if let group_code = group_code {
                                Text("Group Code: \(group_code)")
                            } else {
                                Text("Group Code: N/A")
                            }
                            Button {
                                activeAlert = .leaveGroup
                            } label: {
                                Text("Leave Group")
                            }
                            Button(role: .destructive) {
                                activeAlert = .signOut
                            } label: {
                                Text("Sign Out")
                            }
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 23))
                                .padding()
                        }
                    }.offset(y: -componentOffset * 1.4)
                    
                // MARK: END Zstack
                }.onAppear {
                    group = groupViewModel.getGroupByID(user.group_id!)
                    group_name = group?.name
                    group_code = group?.code
                    tabBarViewModel.hideTabBar = false
                }
                .alert(item: $activeAlert) { alertType in
                    switch alertType {
                    case .leaveGroup:
                        return Alert(
                            title: Text("Confirm"),
                            message: Text("Are you sure you want to leave the group?"),
                            primaryButton: .destructive(Text("Leave")) {
                                // Leave group logic
                                print("Leaving group...")
                                
                                DispatchQueue.main.async {
                                    userViewModel.leaveGroup(currUser: user)
                                    authViewModel.currentUser!.group_id = nil
                                    taskViewModel.unclaimTasksForUserLeavingGroup(uid: user.id!)
                                }
                                
                                
                            },
                            secondaryButton: .cancel()
                        )
                    case .signOut:
                        return Alert(
                            title: Text("Confirm"),
                            message: Text("Are you sure you want to sign out?"),
                            primaryButton: .destructive(Text("Sign Out")) {
                                // Sign out logic
                                print("Signing Out...")
                                authViewModel.signOut()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
        }
    }
}


struct SmallSquare: View {
    @EnvironmentObject var postViewModel: PostViewModel
    @State private var isPopoverPresented = false

    let dayOffset: Int
    let user: User
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    var body: some View {
        let date = Calendar.current.date(byAdding: .day, value: -dayOffset, to: Date()) ?? Date()
        let day = Calendar.current.component(.day, from: date)
        let isToday = Calendar.current.isDateInToday(date)
        let post = postViewModel.getUserPostForDay(user: user, date: date)
        

        RoundedRectangle(cornerRadius: 6)
            .foregroundColor(.clear)
//            .stroke(Color.gray.opacity(0.5), lineWidth: 2)
            .frame(width: UIScreen.main.bounds.width * 0.1, height:  UIScreen.main.bounds.height * 0.0675)
            .padding(2) // Optional: Add padding between squares
            .overlay(
            
                ZStack {
                    if let afterImageURL = post?.afterImageURL,
                       let afterPostURL = URL(string: afterImageURL) {
                            
                            CachedAsyncImage(url: afterPostURL) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width * 0.1, height:  UIScreen.main.bounds.height * 0.0675)
                                    .cornerRadius(6)
                                //                                .overlay(Color.black.opacity(0.35).clipShape(RoundedRectangle(cornerRadius: 25))) // Adjust opacity as needed
                            } placeholder: {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                    .frame(width: UIScreen.main.bounds.width * 0.1, height:  UIScreen.main.bounds.height * 0.0675)
                                    .cornerRadius(6)
                            }
                    }
                   if isToday {
                       Circle()
                           .foregroundColor(deepPurple)
                           .frame(width: UIScreen.main.bounds.width * 0.083)
                   }
                    Text("\(day)")
                        .foregroundColor((isToday || post != nil) ? Color.white : deepPurple)
                        .font(.custom("Lato-Bold", size: 17.5))
               }.onTapGesture {
                   isPopoverPresented = true
               }
               .popover(isPresented: $isPopoverPresented) {
                   // Add your fullscreen content here
                   if let shownPost = post {
                       CalendarPostView(isPresented: $isPopoverPresented, post: shownPost, user: user)
                           .presentationCompactAdaptation(.fullScreenCover)
                   }
               }
               
            )
    }
}

struct LeaveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
          .font(.custom("Lato-Bold", size: 18))
          .foregroundColor(.white)
          .padding(.horizontal)
          .frame(maxWidth: .infinity, minHeight: 50)
          .background(Color(red: 0.439, green: 0.298, blue: 1.0))
          .cornerRadius(16)
    }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
      NavigationStack {
          ProfileView()
              .environmentObject(AuthViewModel.mock())
              .environmentObject(TaskViewModel.mock())
              .environmentObject(UserViewModel.mock())
              .environmentObject(GroupViewModel.mock())
              .environmentObject(PostViewModel.mock())
      }
  }
}


