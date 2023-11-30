import SwiftUI

protocol SliderPickerItem: Equatable, CaseIterable, Hashable {
    var displayValue: String { get }
    var color: Color { get }
    static var allCases: [Self] { get }
}

struct SliderPicker<PickerItem: SliderPickerItem>: View {
  @Binding var selectedItem: PickerItem

  var body: some View {
    
    VStack(alignment: .leading) {
      
      GeometryReader { geometry in
        ZStack(alignment: .leading) {
          // Background view that slides
          RoundedRectangle(cornerRadius: 8)
                .fill(selectedItem.color)
            .frame(width: geometry.size.width / CGFloat(PickerItem.allCases.count), height: geometry.size.height)
            .offset(x: self.calculateOffset(width: geometry.size.width, for: selectedItem))
          
          // Text elements
          HStack {
            ForEach(PickerItem.allCases, id: \.self) { item in
              Text(item.displayValue)
                .font(.custom(selectedItem ==  item ? "Lato-Bold" : "Lato", size: 15))
                .foregroundColor(selectedItem == item ? .white : .black)
                .padding()
                .frame(maxWidth: .infinity)
                .onTapGesture {
                  withAnimation(.easeInOut) {
                    self.selectedItem = item
                  }
                }
            }
          }
        }
      }
    
    .frame(height: 40)
    .padding(.horizontal)
  }
    }

    private func calculateOffset(width: CGFloat, for item: PickerItem) -> CGFloat {
        let segmentWidth = width / CGFloat(PickerItem.allCases.count)
        return segmentWidth * CGFloat(PickerItem.allCases.firstIndex(of: item) ?? 0)
    }
}

//struct SliderPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        SliderPicker(selectedItem: .constant(TaskPriority.medium)) // Example usage
//    }
//}
