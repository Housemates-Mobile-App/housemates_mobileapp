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
    
    @State var scrollOffset: CGFloat = CGFloat.zero
    @State var hideNavigationBar: Bool = false
    
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
                    ObservableScrollView(scrollOffset: self.$scrollOffset) {
                       
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
                    // This is causing some latency issues with the tab bar reappearing when exing housemate profile view
                    }.onChange(of: scrollOffset, perform: { scrollOfset in
                        let offset = scrollOfset + (self.hideNavigationBar ? 50 : 0)
                        if offset > 90 {
                            withAnimation(.easeIn(duration: 1), {
                                self.hideNavigationBar = true
                            })
                        }
                        if offset < 70 {
                            withAnimation(.easeIn(duration: 1), {
                                self.hideNavigationBar = false
                            })
                        }
                    }).navigationTitle("Housemates")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarHidden(hideNavigationBar)
                        .toolbar(.visible, for: .tabBar)
                }
            }
        }
    }
    
    // MARK: https://stackoverflow.com/questions/62142773/hide-navigation-bar-on-scroll-in-swiftui
    struct ScrollViewOffsetPreferenceKey: PreferenceKey {
        typealias Value = CGFloat
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value += nextValue()
        }
    }

    struct ObservableScrollView<Content>: View where Content : View {
        @Namespace var scrollSpace
        @Binding var scrollOffset: CGFloat
        let content: () -> Content
        
        init(scrollOffset: Binding<CGFloat>,
             @ViewBuilder content: @escaping () -> Content) {
            _scrollOffset = scrollOffset
            self.content = content
        }
        
        var body: some View {
            ScrollView {
                    content()
                        .background(GeometryReader { geo in
                            let offset = -geo.frame(in: .named(scrollSpace)).minY
                            Color.clear
                                .preference(key: ScrollViewOffsetPreferenceKey.self,
                                            value: offset)
                        })
                
            }
            .coordinateSpace(name: scrollSpace)
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                scrollOffset = value
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
