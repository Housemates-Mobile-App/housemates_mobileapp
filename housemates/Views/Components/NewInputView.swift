//
//  NewInputView.swift
//  housemates
//  Created by Daniel Fransesco Gunawan on 11/13/23.
//

import SwiftUI

struct NewInputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 20))
                .foregroundColor(.black)
                .bold()
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.white)
                )
        }
    }
}

struct NewInputView_Previews: PreviewProvider {
    static var previews: some View {
        NewInputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
    }
}
