import SwiftUI
import Tonic

struct Dualistic<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    var model: KeyboardModel
    var octaveCount: Int
    let tonic = 32

    var body: some View {
        VStack(spacing: 0) {
            ForEach((0...(octaveCount - 1)).reversed(), id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(-12...12, id: \.self) { col in
                        KeyContainer(model: model,
                                     pitch: Pitch(intValue: row * 12 + col + tonic),
                                     content: content)
                    }
                }
            }
        }
        .clipShape(Rectangle())
    }
}
