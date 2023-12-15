//
//  CalendarPostView.swift
//  housemates
//
//  Created by Sean Pham on 12/13/23.
//

import SwiftUI

struct CalendarPostView: View {
    @EnvironmentObject var postViewModel: PostViewModel
    @Binding var isPresented: Bool
    
    let post: Post
    let user: User
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)

    var body: some View {
        VStack {
            // Post details header
            HStack{
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "chevron.down")
                        .bold()
                        .font(.system(size: 21))
                }.padding(.leading)
                Spacer()
                VStack(alignment: .center) {
                    Text("Completed ").font(.custom("Nunito", size: 16))
                    + Text("\(post.task.name)")
                        .font(.custom("Nunito-Bold", size: 16))
                        .foregroundColor(deepPurple)
                    
                    Text(post.task.date_completed!)
                        .font(.custom("Lato", size: 12))
                }.padding(.trailing,30)
                Spacer()
            }
            
            if let afterImageURL = post.afterImageURL,
               let afterPostURL = URL(string: afterImageURL) {
                
                if let beforeImageURL = post.task.beforeImageURL,
                   let beforePostURL = URL(string: beforeImageURL) {
                    HStack(alignment: .center, spacing: 30) {
                        VStack {
                            CalendarPostPictureView(postURL: beforePostURL)
                            Text("Before")
                                .font(.custom("Nunito-Bold", size: 16))
                                .foregroundColor(deepPurple)

                        }
                        VStack {
                            CalendarPostPictureView(postURL: afterPostURL)
                            Text("After")
                                .font(.custom("Nunito-Bold", size: 16))
                                .foregroundColor(deepPurple)

                        }
                        
                        
                    }.modifier(ScrollingHStackModifier(items: 2, itemWidth: 300, itemSpacing: 30))
                        .padding(.top)
                } else {
                    CalendarPostPictureView(postURL: afterPostURL)
                    Text("After")
                        .font(.custom("Nunito-Bold", size: 16))
                        .foregroundColor(deepPurple)
                }
            }
            Divider()
            let reactions = postViewModel.reactionDict(post: post)
            let comments = post.comments
            
            if reactions.isEmpty && comments.isEmpty {
                Text("No reactions or comments")
                    .font(.custom("Lato", size: 16))
                    .padding()
            } else {
                // REACTIONS
                VStack {
                    if !reactions.isEmpty {
                      
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(Array(reactions), id: \.key) { pair in
                                        let emoji = pair.key
                                        let users = pair.value
                                        
                                        HStack {
                                            Text(emoji)
                                                .font(.system(size: 18)).offset(x: 3)
                                            
                                            
                                            Text("\(users.count)")
                                                .padding(.trailing, 5)
                                                .font(.custom("Lato", size: 15))
                                                .foregroundColor(.primary.opacity(0.75))
                                            
                                        }.padding(6)
                                        
                                            .background(
                                                RoundedRectangle(cornerRadius: 18)
                                                    .fill(.gray.opacity(0.15))
                                                )
                                            .cornerRadius(15)
                                    }
                                
                                }.padding([.leading, .top, .bottom])
                        }
                    }
                    
                    if !comments.isEmpty {
                        List {
                            ForEach(post.comments) { comment in
                                CommentListView(comment: comment)
                            }.listRowSeparator(.hidden)
                        }.listStyle(InsetListStyle())
                    }
                    Spacer()
                }
            }
            Spacer()

        }
    }
}

#Preview {
    CalendarPostView(isPresented: .constant(true), post: PostViewModel.mockPost(), user: UserViewModel.mockUser())
        .environmentObject(PostViewModel.mock())
}

struct CalendarPostPictureView: View {
    let postURL: URL
    var body: some View {
        AsyncImage(url: postURL) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 380)
                .cornerRadius(25)
                .overlay(Color.black.opacity(0.35).clipShape(RoundedRectangle(cornerRadius: 25))) // Adjust opacity as needed
        } placeholder: {
            
            // MARK: Loading wheel as a placeholder
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                .frame(width: 300, height: 380)
                .cornerRadius(25)
                .overlay(Color.black.opacity(0.1).clipShape(RoundedRectangle(cornerRadius: 25))) // Adjust opacity as needed
        }
    }
}

struct ScrollingHStackModifier: ViewModifier {
    
    @State private var scrollOffset: CGFloat
    @State private var dragOffset: CGFloat
    
    var items: Int
    var itemWidth: CGFloat
    var itemSpacing: CGFloat
    
    init(items: Int, itemWidth: CGFloat, itemSpacing: CGFloat) {
        self.items = items
        self.itemWidth = itemWidth
        self.itemSpacing = itemSpacing
        // Calculate Total Content Width
        let contentWidth: CGFloat = CGFloat(items) * itemWidth + CGFloat(items - 1) * itemSpacing
        let screenWidth = UIScreen.main.bounds.width
        
        // Set Initial Offset to first Item

        let initialOffset = (contentWidth/2.0) - (screenWidth/2.0) + ((screenWidth - itemWidth) / 2.0)
        
//        let initialOffset = ((screenWidth - itemWidth) / 2.0) + CGFloat(initialIndex) * (itemWidth + itemSpacing)

        self._scrollOffset = State(initialValue: initialOffset)
        self._dragOffset = State(initialValue: 0)
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: scrollOffset + dragOffset, y: 0)
            .gesture(DragGesture()
                .onChanged({ event in
                    dragOffset = event.translation.width
                })
                .onEnded({ event in
                    // Scroll to where user dragged
                    scrollOffset += event.translation.width
                    dragOffset = 0
                    
                    // Now calculate which item to snap to
                    let contentWidth: CGFloat = CGFloat(items) * itemWidth + CGFloat(items - 1) * itemSpacing
                    let screenWidth = UIScreen.main.bounds.width
                    
                    // Center position of current offset
                    let center = scrollOffset + (screenWidth / 2.0) + (contentWidth / 2.0)
                    
                    // Calculate which item we are closest to using the defined size
                    var index = (center - (screenWidth / 2.0)) / (itemWidth + itemSpacing)
                    
                    // Should we stay at current index or are we closer to the next item...
                    if index.remainder(dividingBy: 1) > 0.5 {
                        index += 1
                    } else {
                        index = CGFloat(Int(index))
                    }
                    
                    // Protect from scrolling out of bounds
                    index = min(index, CGFloat(items) - 1)
                    index = max(index, 0)
                    
                    // Set final offset (snapping to item)
                    let newOffset = index * itemWidth + (index - 1) * itemSpacing - (contentWidth / 2.0) + (screenWidth / 2.0) - ((screenWidth - itemWidth) / 2.0) + itemSpacing
                    
                    // Animate snapping
                    withAnimation {
                        scrollOffset = newOffset
                    }
                    
                })
            )
    }
}
