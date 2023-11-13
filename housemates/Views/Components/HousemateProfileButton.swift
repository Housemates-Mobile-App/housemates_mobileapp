//
//  HousemateProfileButton.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/12/23.
//

import SwiftUI

struct HousemateProfileButton: View {
    var phoneNumber: String
    var title: String
    var iconStr: String
    var urlScheme: String
        
    var body: some View {
        VStack {
            Button(action: {
                if let url = URL(string: "\(urlScheme)://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 65, height: 48)
                    .overlay(
                        VStack(spacing: 5) {
                            Image(iconStr)
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text(title)
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                                .bold()
                        }
                    )
            }
        }
    }
}

#Preview {
    HousemateProfileButton(phoneNumber: "1234567890", title: "Call", iconStr: "call-phone", urlScheme:"tel")
}
