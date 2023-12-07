//
//  PostPictureView.swift
//  housemates
//
//  Created by Sean Pham on 12/2/23.
//

import SwiftUI
import CachedAsyncImage

struct PostPictureView: View {
//    @GestureState private var zoom = 1.0

    let postURL: URL
    var body: some View {
        AsyncImage(url: postURL) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 380, height: 490)
                .cornerRadius(25)
                .overlay(Color.black.opacity(0.35).clipShape(RoundedRectangle(cornerRadius: 25)))
                .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 100, pressing: {
                                           pressing in
                                           print(pressing)
                                       }, perform: {})// Adjust opacity as needed
//                .scaleEffect(zoom)
//                .simultaneousGesture(
//                    MagnifyGesture()
//                        .updating($zoom) { value, gestureState, transaction in
//                            gestureState = value.magnification
//                        }
////                    DragGesture()
////                        .onChanged { value in
////                            // Handle the drag gesture here
////                            // You can use value.translation to get the drag distance
////                        }
//                )

        } placeholder: {
            
            // MARK: Loading wheel as a placeholder
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                .frame(width: 380, height: 490)
                .cornerRadius(25)
                .overlay(Color.black.opacity(0.1).clipShape(RoundedRectangle(cornerRadius: 25))) // Adjust opacity as needed
        }
    }
}

//#Preview {
//    PostPictureView()
//}

