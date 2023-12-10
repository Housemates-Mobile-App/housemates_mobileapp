//
//  housematesApp.swift
//  housemates
//
//  Created by Sean Pham on 10/31/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct housematesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var taskViewModel = TaskViewModel()
    @StateObject var userViewModel = UserViewModel()
    @StateObject var groupViewModel = GroupViewModel()
    @StateObject var postViewModel = PostViewModel()
    @StateObject var tabBarViewModel = TabBarViewModel()
    @StateObject var friendInfoViewModel = FriendInfoViewModel()
    
    @State var hideTabBar: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(taskViewModel)
                .environmentObject(userViewModel)
                .environmentObject(groupViewModel)
                .environmentObject(postViewModel)
                .environmentObject(tabBarViewModel)
                .environmentObject(friendInfoViewModel)
        }
    }
}
