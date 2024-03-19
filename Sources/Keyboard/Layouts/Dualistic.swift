import SwiftUI
import Tonic

struct Dualistic<Content>: View where Content: View {
    let content: (KeyboardCell, Pitch, Bool) -> Content
    var model: KeyboardModel
    var octaveShift: Int
    var octaveCount: Int
    var keysPerRow: Int
    var tonicPitchClass: Int
    var upwardPitchMovement: Bool
    let initialC: Int
    
    var body: some View {
        let tonicPitch : Int = initialC + tonicPitchClass
        
        let extraColsPerSide : Int = Int(floor(CGFloat(keysPerRow - 13) / 2))
        let extraRowsPerSide : Int = Int(floor(CGFloat(octaveCount - 1) / 2))
        VStack(spacing: 0) {
            ForEach((-extraRowsPerSide...extraRowsPerSide).reversed(), id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(-extraColsPerSide...(12+extraColsPerSide), id: \.self) { col in
                        let midi = row * 12 + col + tonicPitch + 12 * octaveShift - (upwardPitchMovement ? 0 : 12)
                        if (midi >= 0 && midi <= 127) {
                            KeyContainer(model: model,
                                         keyboardCell: KeyboardCell(row: row, col: col, pitch: Pitch(intValue: midi)),
                                         pitch: Pitch(intValue: midi),
                                         content: content)
                        } else {
                            Color.clear
                        }
                    }
                }
            }
        }
        .clipShape(Rectangle())
    }
}
