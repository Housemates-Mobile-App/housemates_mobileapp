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
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Lato-Bold", size: 18))
                
                
            TextField(placeholder, text: $text)
                .font(.custom("Lato", size: 14))
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.white)
                )
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct NewInputView_Previews: PreviewProvider {
    static var previews: some View {
        NewInputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
    }
}
