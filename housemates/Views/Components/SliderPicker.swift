//
//  SliderPicker.swift
//  housemates
//  referenced from: https://www.youtube.com/watch?v=sqrW8RGtn40
//  Created by Daniel Fransesco Gunawan on 11/13/23.
//

import SwiftUI

struct SliderPicker: View {
    @EnvironmentObject var taskViewModel : TaskViewModel
    @Namespace private var namespace

    let elements: [TaskViewModel.TaskPriority] = TaskViewModel.TaskPriority.allCases
    
    @Binding var selectedElement: TaskViewModel.TaskPriority
    
    let color = Color.red
    let selectedColor = Color.green
    
    var body: some View {
        HStack (spacing: 70) {
            ForEach(elements, id: \.self) { priority in
                Text(priority.rawValue)
                    .foregroundColor(selectedElement.rawValue == priority.rawValue ? selectedColor : color)
                    .bold()
                    .background(
                        Color.clear
                            .frame(height: 2)
                            .matchedGeometryEffect(id: priority, in: namespace, properties: .frame, isSource: true)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    )
                    .onTapGesture {
                        withAnimation {
                            selectedElement = priority
                        }
                    }
            }.background(
                selectedColor
                    .matchedGeometryEffect(id: selectedElement, in: namespace, properties: .frame, isSource: false)
            )
        }
        .padding(10)
        .background(
            VStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(.white)
            }
        )
    }
}

#Preview {
    SliderPicker(selectedElement: Binding.constant(TaskViewModel.TaskPriority.medium))
        .environmentObject(TaskViewModel())
}
