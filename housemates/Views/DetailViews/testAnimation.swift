//
//  testAnimation.swift
//  housemates
//
//  Created by Daniel Gunawan on 12/11/23.
//

import SwiftUI

struct AnimationView: View {
    @State private var isExpanded = false
    @State private var isRowCardVisible = true

    var body: some View {
        VStack {
                    if isRowCardVisible {
                        ZStack {
                            // Background that will expand
                            Color.purple
                                .frame(width: isExpanded ? UIScreen.main.bounds.width : 0, height: 50)
                                .opacity(isExpanded ? 1 : 0)
                                .scaleEffect(isExpanded ? 1 : 0.1, anchor: .center)
                                .animation(Animation.easeInOut(duration: 1.0), value: isExpanded)

                            // Press Me Button
                            Button(action: {
                                withAnimation {
                                    isExpanded.toggle()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                                    isRowCardVisible = false
                                }
                            }) {
                                Text("Press Me")
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.purple))
                            }
                            .scaleEffect(isExpanded ? 1 : 1, anchor: .center)
                        }
                        .frame(height: 50)
                        .padding()
                    }

                    // Reset Button
                    Button("Reset") {
                        isRowCardVisible = true
                        isExpanded = false
                    }
                    .padding()
                }    }
}

struct AnimationView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationView()
    }
}
