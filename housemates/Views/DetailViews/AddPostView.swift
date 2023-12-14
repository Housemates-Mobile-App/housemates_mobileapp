//
//  AddPostView.swift
//  housemates
//
//  Created by Sean Pham on 11/15/23.
//

import SwiftUI
import CachedAsyncImage

struct AddPostView: View {
    let task: task
    let user: User
    let image: UIImage?
    @State private var caption: String = ""
    @EnvironmentObject var tabBarViewModel : TabBarViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var postViewModel: PostViewModel
    
    var body: some View {
        NavigationView {
            VStack {
//                if let uiImage = image {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxWidth: .infinity)
//                        .padding(.top)
//                }
                TabView {
                    if let beforeImageUrl = task.beforeImageURL, let url = URL(string: beforeImageUrl) {
                        VStack {
                            CachedAsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                    .resizable()
                                    .cornerRadius(25)
                                    .overlay(Color.black.opacity(0.35).clipShape(RoundedRectangle(cornerRadius: 25)))
                                case .failure:
                                    Image(systemName: "photo")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .scaledToFit()

                            Text("Before")
                                .font(.headline)
                        }
                    }

                    if let afterImage = image {
                        VStack {
                            Image(uiImage: afterImage)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(25)
                                .overlay(Color.black.opacity(0.35).clipShape(RoundedRectangle(cornerRadius: 25)))

                            Text("After")
                                .font(.headline)
                        }
                    }
                }
                .frame(height: 300)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

                TextField("Add a caption...", text: $caption)
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(10)
                    .padding()

                Spacer()

                Button(action: sharePost) {
                    Text("Share")
                      
                        .font(.custom("Nunito-Bold", size: 18))
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color(red: 0.439, green: 0.298, blue: 1.0))
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .padding(.horizontal)
                }
            }
            .navigationBarTitle("New Post", displayMode: .inline)
            .padding(.bottom, 50)
            .onAppear {
                tabBarViewModel.hideTabBar = true
            }
            .onDisappear {
                withAnimation(.easeIn(duration: 0.2), {
                    tabBarViewModel.hideTabBar = false
                })
            }
        }
    }

    private func sharePost() {
        if let uiImage = image {
            Task {
                await postViewModel.sharePost(user: user, task: task, image: uiImage, caption: caption)
            }
        }
        tabBarViewModel.selectedTab = 0
        tabBarViewModel.showAddPostBanner = true
        presentationMode.wrappedValue.dismiss()
    }
}
//
//#Preview {
//    AddPostView(task: TaskViewModel.mockTask(), user: UserViewModel.mockUser())
//}
