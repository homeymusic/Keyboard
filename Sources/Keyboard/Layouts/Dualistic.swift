import SwiftUI
import Tonic

// safety valve
func safeMIDI(_ p: Int) -> Int {
    if p > -1 && p < 128 {
        return p
    } else {
        return p % 12
    }
}

struct Dualistic<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    var model: KeyboardModel
    var octaveCount: Int
    var keysPerRow: Int
    var tonicPitchClass: Int
    let initialC: Int
    
    var body: some View {
        let tonicPitch : Int = initialC + tonicPitchClass
        
        let extraColsPerSide : Int = Int(floor(CGFloat(keysPerRow - 13) / 2))
        let extraRowsPerSide : Int = Int(floor(CGFloat(octaveCount - 1) / 2))
        VStack(spacing: 0) {
            ForEach((-extraRowsPerSide...extraRowsPerSide).reversed(), id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(-extraColsPerSide...(12+extraColsPerSide), id: \.self) { col in
                        KeyContainer(model: model,
                                     pitch: Pitch(intValue: safeMIDI(row * 12 + col + tonicPitch)),
                                     content: content)
                    }
                }
            }
        }
        .clipShape(Rectangle())
    }
}
