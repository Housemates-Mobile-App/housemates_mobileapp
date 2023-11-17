//
//  InputView.swift
//  housemates
// Code referenced from https://www.youtube.com/watch?v=QJHmhLGv-_0&ab_channel=AppStuff
//  Created by Sanmoy Karmakar on 10/31/23.
// altered to be just an input field (text or secure)

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        // MARK: Input field view for Form
            
        VStack(alignment: .leading) {
    
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.custom("Nunito", size: 24))
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            } else {
                TextField(placeholder, text: $text)
                    .font(.custom("Nunito", size: 24))
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
        }.padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
            .stroke(Color(red: 0.588, green: 0.584, blue: 0.584))
            .padding(.horizontal)
            )
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
    }
}
