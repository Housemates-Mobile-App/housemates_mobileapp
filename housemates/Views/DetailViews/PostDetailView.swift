import SwiftUI
import CachedAsyncImage

struct PostDetailView: View {
    @EnvironmentObject var postViewModel : PostViewModel
    @EnvironmentObject var tabBarViewModel : TabBarViewModel
    @State private var newComment: String = ""
    let post : Post
    let user : User

    var body: some View {
            VStack {
                let beforeImageURL = URL(string: post.task.beforeImageURL ?? "")
                let afterImageURL = URL(string: post.afterImageURL ?? "")
                // Post details header
                VStack(alignment: .center) {
                    Text("\(post.created_by.first_name)").bold().foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0)).font(.custom("Nunito-Bold", size: 15))
                    + Text(" completed ").font(.custom("Nunito", size: 15))
                    + Text("\(post.task.name)").bold().foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0)).font(.custom("Nunito-Bold", size: 15))

                    Text(post.task.date_completed!)
                        .font(.custom("Nunito-Bold", size: 12))
                }
                
                // Image
                    if beforeImageURL != nil {
                        // If there is a before image, use TabView to show both before and after
                        TabView {
                            ForEach([("Before", beforeImageURL), ("After", afterImageURL)], id: \.0) { (description, url) in
                                if let imageURL = url {
                                    VStack {
                                        CachedAsyncImage(url: imageURL) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .cornerRadius(25)
                                                    .overlay(Color.black.opacity(0.35).clipShape(RoundedRectangle(cornerRadius: 25)))
                                            case .failure:
                                                Image(systemName: "photo")
                                                    .foregroundColor(.gray)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        Text(description)
                                            .font(.headline)
                                            .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                                    }
                                }
                            }
                        }
                        .frame(height: 300)
                        .background(Color(UIColor.systemBackground).opacity(0.6))
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    } else if let afterImageURL = afterImageURL {
                        // If there is no before image, just show the after image without TabView
                        VStack {
                            CachedAsyncImage(url: afterImageURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(25)
                                        .overlay(Color.black.opacity(0.35)
                                        .clipShape(RoundedRectangle(cornerRadius: 25)))
                                case .failure:
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            Text("After")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                        }
                        .frame(height: 300)
                    }

                
                
                // Image, Description, and Priority
                VStack(alignment: .center, spacing: -5) {
                    // Image would go here - you'll need to implement this
                    if post.task.description != "" {
                        Text("Description: ").font(.custom("Nunito", size: 15))
                        + Text("\(post.task.description)").bold().foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0)).font(.custom("Nunito-Bold", size: 15))
                    }
                    
                    Text("Priority: ").font(.custom("Nunito", size: 15))
                    + Text("\(post.task.priority)").bold().foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0)).font(.custom("Nunito-Bold", size: 15))
//                    Text("**Priority:** \(post.task.priority)")
//                        .font(.custom("Nunito-Bold", size: 15))
//                        .padding(.top, 2)
                }
                .padding([.top, .horizontal])

                // Reactions, Comments, and Likes
                HStack {
//                    likeButton(post: post, user: user).foregroundColor(.black)
//                    Text("\(post.num_likes) Likes")
//                        .font(.custom("Lato", size: 15))
                    Spacer()
                    Image(systemName: "bubble.left")
                    Text("\(post.num_comments) Comments")
                        .font(.custom("Nunito", size: 15))
                }
                .padding(.horizontal)
                
                Divider()

                // Comments
                List {
                    ForEach(post.comments) { comment in
                        CommentListView(comment: comment)
                    }
                }.listStyle(InsetListStyle())
                
                Spacer()

                // Comment Input Section
                HStack {
                    TextField("Add a comment...", text: $newComment)
                        .font(.custom("Nunito", size: 15))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        // Action to add comment
                    }) {
                        Image(systemName: "arrow.up.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }
                .padding(.bottom)
                
            }
            .onAppear {
                tabBarViewModel.hideTabBar = true
            }
            .onDisappear {
                withAnimation(.easeIn(duration: 0.2), {
                    tabBarViewModel.hideTabBar = false
                })
            }
        }

    
    // MARK: Like / Unlike Button
    func likeButton(post: Post, user: User) -> some View {
        HStack {
            // MARK: If user has liked post show unlike button else show like button
            if post.liked_by.contains(where: {$0 == user.id}) {
                Button(action: {
                    postViewModel.unlikePost(user: user, post: post)
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                }
            } else {
                Button(action: {
                    postViewModel.likePost(user: user, post: post)
                }) {
                    Image(systemName: "heart")
                        .font(.system(size: 20))
                }
            }
        }
    }
    
    //#Preview {
    //    PostDetailView(post: PostViewModel.mockPost(), user: UserViewModel.mockUser())
    //}
}
