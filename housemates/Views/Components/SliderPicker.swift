import SwiftUI

protocol SliderPickerItem: Equatable, CaseIterable, Hashable {
    var displayValue: String { get }
    var color: Color { get }
    static var allCases: [Self] { get }
}
struct SliderPicker<PickerItem: SliderPickerItem>: View {
  @Binding var selectedItem: PickerItem
  let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
  var body: some View {
    VStack(alignment: .leading) {
      GeometryReader { geometry in
        ZStack(alignment: .leading) {
          // Background view that slides
          RoundedRectangle(cornerRadius: 10)
                .fill(deepPurple)
                .frame(width: geometry.size.width / CGFloat(PickerItem.allCases.count), height: geometry.size.height)
                .offset(x: self.calculateOffset(width: geometry.size.width, count: PickerItem.allCases.count, index: PickerItem.allCases.firstIndex(of: selectedItem) ?? 0))

          // Text elements
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
              ForEach(PickerItem.allCases, id: \.self) { item in
                Text(item.displayValue)
                  .font(.custom(selectedItem ==  item ? "Lato-Bold" : "Lato", size: 14))
                  .foregroundColor(selectedItem == item ? .white : .black)
                  .padding()
                  .frame(minWidth: geometry.size.width / CGFloat(PickerItem.allCases.count), alignment: .center)
                  .onTapGesture {
                    withAnimation(.easeInOut) {
                      selectedItem = item
                    }
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

  private func calculateOffset(width: CGFloat, count: Int, index: Int) -> CGFloat {
      let segmentWidth = width / CGFloat(count)
      return segmentWidth * CGFloat(index)
  }
}
