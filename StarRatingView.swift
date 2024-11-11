import SwiftUI

struct StarView: View {
    @Binding var rating: Double
    let starSize: CGFloat
    let starPadding: CGFloat
    let starCount: Int
    
    init(rating: Binding<Double>, starSize: CGFloat = 38, starPadding: CGFloat = 8, starCount: Int = 5) {
        self._rating = rating
        self.starSize = starSize
        self.starPadding = starPadding
        self.starCount = starCount
    }
    
    var body: some View {
        HStack(spacing: starPadding) {
            ForEach(0..<starCount, id: \.self) { index in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundStyle(Color.gray)
                        .frame(width: starSize, height: starSize)
                    Rectangle()
                        .foregroundStyle(Color.yellow)
                        .frame(width: starSize * max(min(rating - Double(index) ,1.0), 0.0), height: starSize)
                }
                .mask {
                    Image(systemName: "star.fill")
                        .resizable()
                }
                .aspectRatio(contentMode: .fit)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let starSizeWithPadding = starSize + starPadding
                    
                    let starIndex = Int(value.location.x / starSizeWithPadding)
                    let positionInStar = value.location.x.truncatingRemainder(dividingBy: starSizeWithPadding)
                    
                    if positionInStar <= starSize {
                        var newRating = Double(starIndex) + Double(positionInStar / starSize)
                        newRating = (newRating * 2).rounded() / 2
                        rating = min(max(newRating, 0), Double(starCount))
                    }
                }
        )
    }
}
