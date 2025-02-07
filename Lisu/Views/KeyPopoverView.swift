import SwiftUI

struct KeyPopoverView: View {
    let key: String
    let width: CGFloat
    
    var body: some View {
        ZStack {
            // Background shape with arrow
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: KeyboardConstants.popoverRadius)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .frame(width: width * 1.2, height: 35)
                    .shadow(color: Color.primary.opacity(0.15), radius: 1, x: 0, y: 1)
                
                // Arrow
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.system(size: 8))
                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                    .offset(y: -2)
            }
            
            // Key text
            Text(key)
                .font(FontHelper.customFont(size: 28))
                .foregroundColor(Color(UIColor.label))
                .offset(y: -2)
        }
        .frame(width: width * 1.2, height: 44)
    }
}
