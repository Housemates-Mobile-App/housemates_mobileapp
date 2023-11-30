//
//  AddPostView.swift
//  housemates
//
//  Created by Sean Pham on 11/15/23.
//

import SwiftUI

struct AddPostView: View {
    let task: task
    let user: User
    let image: UIImage?
    @State private var caption: String = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var postViewModel: PostViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if let uiImage = image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                }

                TextField("Add a caption...", text: $caption)
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(10)
                    .padding()

                Spacer()

                Button(action: sharePost) {
                    Text("Share")
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .navigationBarTitle("New Post", displayMode: .inline)
            .padding(.bottom, 50)
        }
    }

    private func sharePost() {
        if let uiImage = image {
            Task {
                await postViewModel.sharePost(user: user, task: task, image: uiImage, caption: caption)
            }
        }
        presentationMode.wrappedValue.dismiss()
    }
}
//
//#Preview {
//    AddPostView(task: TaskViewModel.mockTask(), user: UserViewModel.mockUser())
//}
