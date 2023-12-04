//
//  HomeView.swift
//  housemates
//
import Foundation
import SwiftUI
import SwiftUITrackableScrollView

struct HomeView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    @EnvironmentObject var postViewModel : PostViewModel
    
    @State var isHiding : Bool = false
    @State var scrollOffset : CGFloat = 0
    @State var threshHold : CGFloat = 0
    
    // MARK: https://www.hackingwithswift.com/forums/swiftui/custom-font-in-navigation-title-and-back-button/22989 To change stlye of navigationTitle
    
    init() {
        let appear = UINavigationBarAppearance()

        let atters: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Nunito-Bold", size: 26)!,
            .foregroundColor: UIColor(red: 0.439, green: 0.298, blue: 1.0, alpha: 1.0)
        ]
        
        appear.largeTitleTextAttributes = atters
        appear.titleTextAttributes = atters
        UINavigationBar.appearance().standardAppearance = appear
     }
    
    var body: some View {
        if let user = authViewModel.currentUser {
            NavigationStack {
                VStack {
                    // MARK: Vertical Scroll View
                    ScrollView(.vertical) {
                        
                        // MARK: Horizontal Housemates Scroll View
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                if let uid = user.id {
                                    ForEach(userViewModel.getUserGroupmates(uid)) { user in
                                        NavigationLink(destination: HousemateProfileView(housemate: user)                                         .toolbar(.hidden, for: .tabBar)
                                        ) {
                                            HousemateCircleComponent(housemate: user)
                                        }.buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }.padding(.horizontal)
                                .padding(.bottom)
                        }
                        
                        if let group_id = user.group_id {
                            ForEach(postViewModel.getPostsForGroup(group_id)) { post in
                                PostRowView(post: post, user: user).padding(.bottom, 5)
                            }
                        }
                        
                        // MARK: reads position of stuff to display nav and tool bars
                        GeometryReader { proxy in
                            Color.clear
                                .changeOverlayOnScroll(
                                    proxy: proxy,
                                    offsetHolder: $scrollOffset,
                                    thresHold: $threshHold,
                                    toggle: $isHiding
                                )
                        }
                    }.navigationTitle("Housemates")
                        .navigationBarTitleDisplayMode(.inline)
                        .coordinateSpace(name: "scroll")
                        .toolbar(isHiding ? .hidden : .visible, for: .navigationBar)
                        .toolbar(isHiding ? .hidden : .visible, for: .tabBar)
                }
            }
        }
    }
}

// Source: https://stackoverflow.com/questions/76551783/swiftui-hiding-tabbar-and-navigationbar-on-scroll
extension View {
    
    func changeOverlayOnScroll(
        proxy : GeometryProxy,
        offsetHolder : Binding<CGFloat>,
        thresHold : Binding<CGFloat>,
        toggle: Binding<Bool>
    ) -> some View {
        self
            .onChange(
                of: proxy.frame(in: .named("scroll")).minY
            ) { newValue in
                // Set current offset
                offsetHolder.wrappedValue = abs(newValue)
                // If current offset is going downward we hide overlay after 200 px.
                if offsetHolder.wrappedValue > thresHold.wrappedValue + 200 {
                    // We set thresh hold to current offset so we can remember on next iterations.
                    thresHold.wrappedValue = offsetHolder.wrappedValue
                    // Hide overlay
                    withAnimation(.easeIn(duration: 1), {
                        toggle.wrappedValue = false
                    })
                    
                    // If current offset is going upward we show overlay again after 200 px
                }else if offsetHolder.wrappedValue < thresHold.wrappedValue - 200 {
                    // Save current offset to threshhold
                    thresHold.wrappedValue = offsetHolder.wrappedValue
                    // Show overlay
                    withAnimation(.easeIn(duration: 1), {
                        toggle.wrappedValue = true
                    })
                }
         }
    }
}




struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel.mock())
            .environmentObject(UserViewModel.mock())
            .environmentObject(PostViewModel())

    }
}
