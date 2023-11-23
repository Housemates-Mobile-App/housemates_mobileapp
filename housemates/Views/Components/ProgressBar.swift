//
//  ProgressBar.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/18/23.
//

import SwiftUI

struct ProgressBar: View {
    var progress: Float

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(.gray)

                Rectangle().frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                    .animation(.linear, value: progress)
            }.cornerRadius(45.0)
        }
    }
}

//#Preview {
//    ProgressBar(progress:0.25)
//}
