//
//  ActivityView.swift
//  housemates
//
//  Created by Sean Pham on 12/6/23.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var postViewModel : PostViewModel
    @EnvironmentObject var tabBarViewModel : TabBarViewModel
    @Environment(\.presentationMode) var presentationMode: Binding
       
          
        
    let user: User
    var body: some View {
        let activities = postViewModel.getActivity(user: user)
        let postList = activities.0
        let activityList = activities.1
        
        VStack(alignment: .leading, spacing: 10) {
            if activityList.isEmpty {
                Spacer()
                Text("No Recent Activity")
                    .foregroundColor(.gray)
                    .font(.custom("Nunito-Bold", size: 23))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Spacer()
            } else {
                ScrollView(.vertical) {
                    ForEach(Array(postList.enumerated()), id: \.offset) { index, post in
                        let activity = activityList[index]
                        if let comment = activity as? Comment {
                            CommentActivityView(comment: comment, post: post)
                        } else if let reaction = activity as? Reaction {
                            ReactionActivityView(reaction: reaction, post: post)
                        }
                    }
                }
            }
        }
        .padding(.top, 5)
        .onAppear {
            tabBarViewModel.hideTabBar = true
        }
        .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton())
     }
     private func BackButton() -> some View {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left") // set image here
                    Text("Notifications")
                        .font(.custom("Nunito-Bold", size: 23))
            }
        }
    }
}


extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
//
//#Preview {
//    ActivityView(user: UserViewModel.mockUser())
//        .environmentObject(PostViewModel.mock())
//        .environmentObject(TabBarViewModel.mock())
//}
