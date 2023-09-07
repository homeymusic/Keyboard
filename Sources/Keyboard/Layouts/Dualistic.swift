import SwiftUI
import Tonic

struct Dualistic<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    var model: KeyboardModel
    var octaveCount: Int
    var tonicPitchClass: Int
    let keysPerRow: Int = 25
    let lowestC = 24
    
    var body: some View {
        let extraKeysPerSide : Int = Int(floor(CGFloat((keysPerRow - 13) / 2)))
        
        GeometryReader { proxy in
            VStack(spacing: 0) {
                ForEach((0...(octaveCount - 2)).reversed(), id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(-extraKeysPerSide...(12+extraKeysPerSide), id: \.self) { col in
                            KeyContainer(model: model,
                                         pitch: Pitch(intValue: row * 12 + col + lowestC + tonicPitchClass),
                                         content: content)
                        }
                    }
                    .frame(maxHeight: proxy.size.width / CGFloat(keysPerRow) * 4.5)
                }
            }
        }
        .clipShape(Rectangle())
    }
}
