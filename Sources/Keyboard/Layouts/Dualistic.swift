import SwiftUI
import Tonic

struct Dualistic<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    var model: KeyboardModel
    var octaveCount: Int
    var tonicPitchClass: Int
    let aspectRatio: CGFloat
    let lowestC: Int = 24
    let middleC: Int = 60

    var body: some View {
        let middleOctave : Int = Int(floor(Double((octaveCount)/2) + 1) * 12)
        let middleTonic : Int = middleC - middleOctave + tonicPitchClass
        let aspectRatio: CGFloat = aspectRatio

        GeometryReader { proxy in

            let keysPerRow: Int = (proxy.size.width > 800) ? 25 : 13
            let extraKeysPerSide : Int = Int(floor(CGFloat(keysPerRow - 13) / 2))

            VStack(spacing: 0) {
                ForEach((1...(octaveCount)).reversed(), id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(-extraKeysPerSide...(12+extraKeysPerSide), id: \.self) { col in
                            KeyContainer(model: model,
                                         pitch: Pitch(intValue: row * 12 + col + middleTonic),
                                         content: content)
                        }
                    }
                    .frame(maxHeight: proxy.size.width / CGFloat(keysPerRow) * aspectRatio)
                }
            }
        }
        .clipShape(Rectangle())
    }
}
