//
//  FlashcardComponent.swift
//  housemates
//  referenced from https://www.youtube.com/watch?v=v2Xf1gwcQSA
//  Created by Daniel Fransesco Gunawan on 11/14/23.
//

import SwiftUI

struct FlashcardComponent: View {
    
    var front : any View
    var back: any View
    
    @State var isFlipped: Bool = false
    @State var flashcardComponentRotation = 0.0
    @State var contentRotation = 0.0
    
    
    var body: some View {
        ZStack {
            if isFlipped {
                AnyView(back)
            } else {
                AnyView(front)
            }
        }
        .rotation3DEffect(
            .degrees(contentRotation), axis: (x:0, y:1, z:0)
        )
        .frame(height: 300)
        .frame(width: 250)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.black, lineWidth: 2)
        )
        .onTapGesture {
            flipFlashcardComponent()
        }
        .rotation3DEffect(.degrees(flashcardComponentRotation), axis: (x: 0, y: 1, z: 0))
    }
    func flipFlashcardComponent() {
        let animationTime = 0.4
        withAnimation(Animation.linear(duration:animationTime)) {
            flashcardComponentRotation += 180
        }
        
        withAnimation(Animation.linear(duration:0.001).delay(animationTime / 2)) {
            contentRotation += 180
            isFlipped.toggle()
        }
    }
}

#Preview {
    FlashcardComponent(front: Text("front"), back: Text("back"))
}
