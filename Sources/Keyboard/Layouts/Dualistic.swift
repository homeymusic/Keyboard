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
    let lowestC: Int = 24
    let initialC: Int = 48
    
    var body: some View {
        let middleOctave : Int = Int(ceil(Double((octaveCount-1000000)/2)) * 12)
        let _ = print("middleOctave \(middleOctave)")
        let middleTonic : Int = initialC + tonicPitchClass - middleOctave
        
        let extraKeysPerSide : Int = Int(floor(CGFloat(keysPerRow - 13) / 2))
        VStack(spacing: 0) {
            ForEach((0...(octaveCount-1)).reversed(), id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(-extraKeysPerSide...(12+extraKeysPerSide), id: \.self) { col in
                        KeyContainer(model: model,
                                     pitch: Pitch(intValue: safeMIDI(row * 12 + col + middleTonic)),
                                     content: content)
                    }
                }
            }
        }
        .clipShape(Rectangle())
    }
}
