//
//  GraphFilterView.swift
//  housemates
//
//  Created by Bernard Sheng on 12/6/23.
//

import Foundation

import SwiftUI

struct GraphFilterView: View {
    @Binding var selected: String
    @Binding var showDropdown: Bool

    let options = ["All Time", "Last Month", "Last Week", "Today"]
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Main Button
            Button(action: {
                withAnimation {
                    showDropdown.toggle()
                }
            }) {
                HStack {
                    Text(selected)
                        .font(.custom("Lato-Bold", size: 12))
                    
                    Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
                        .resizable()
                        .frame(width: 10, height: 5)
                }
                .frame(width: 80)
                .padding(.all, 10)
                .background(deepPurple)
                .foregroundColor(.white)
                .cornerRadius(25)
            }
//            .frame(maxWidth: 200)
        }
    }

   
    func dropdownOptions() -> some View {
        VStack(alignment: .leading) {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    withAnimation {
                        selected = option
                        showDropdown = false
                    }
                }) {
                    Text(option)
                        .font(.custom("Lato-Bold", size: 12))
                        .padding(.vertical, 5)
                        .foregroundColor(option == selected ? .gray : deepPurple)
                        .frame(width: 80)
                }
                .padding(.horizontal, 10)
//                .foregroundColor(deepPurple)
            }
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(deepPurple, lineWidth: 1)
        )
//        .frame(maxWidth: 200)
    }
}
