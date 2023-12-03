//
//  PostPictureView.swift
//  housemates
//
//  Created by Sean Pham on 12/2/23.
//

import SwiftUI

struct PostPictureView: View {
    let postURL: URL
    var body: some View {
        AsyncImage(url: postURL) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 380, height: 490)
                .cornerRadius(25)
                .overlay(Color.black.opacity(0.35).clipShape(RoundedRectangle(cornerRadius: 25))) // Adjust opacity as needed
        } placeholder: {
            
            // MARK: Loading wheel as a placeholder
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                .frame(width: 380, height: 490)
                .cornerRadius(25)
        }
    }
}

//#Preview {
//    PostPictureView()
//}
