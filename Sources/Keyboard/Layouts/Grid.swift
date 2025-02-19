import SwiftUI
import Tonic

struct Grid<Content>: View where Content: View {
    let content: (KeyboardCell, Pitch, Bool) -> Content
    var model: KeyboardModel
    var octaveShift: Int
    var octaveCount: Int
    var keysPerRow: Int
    var tonicPitchClass: Int
    var upwardPitchMovement: Bool
    let initialC: Int
    let doubleColumns = [1,3,8,10]
    let skipColumns = [2,4,6,7,9,11]
    
    func tritoneLength(_ proxySize: CGSize) -> CGFloat {
        return min(proxySize.height * 0.3125, proxySize.width * 1.0)
    }
    
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
                            if (doubleColumns.contains(mod(col, 12))) {
                                VStack(spacing: 0) {
                                    KeyContainer(model: model,
                                                 keyboardCell: KeyboardCell(row: row, col: col+1, pitch: Pitch(intValue: midi+1)),
                                                 pitch: Pitch(intValue: midi+1),
                                                 content: content)
                                    KeyContainer(model: model,
                                                 keyboardCell: KeyboardCell(row: row, col: col, pitch: Pitch(intValue: midi)),
                                                 pitch: Pitch(intValue: midi),
                                                 content: content)
                                }
                                .padding(0)
                            } else if (mod(col, 12) == 5) {
                                KeyContainer(model: model,
                                             keyboardCell: KeyboardCell(row: row, col: col, pitch: Pitch(intValue: midi)),
                                             pitch: Pitch(intValue: midi),
                                             content: content)
                                KeyContainer(model: model,
                                             keyboardCell: KeyboardCell(row: row, col: col+2, pitch: Pitch(intValue: midi+2)),
                                             pitch: Pitch(intValue: midi+2),
                                             content: content)
                                .overlay() {
                                    GeometryReader { proxy in
                                        let ttLength = tritoneLength(proxy.size)
                                        KeyContainer(model: model,
                                                     keyboardCell: KeyboardCell(row: row, col: col + 1, pitch: Pitch(intValue: midi + 1)),
                                                     pitch: Pitch(intValue: midi + 1),
                                                     zIndex: 1,
                                                     content: content)
                                        .frame(width: ttLength, height: ttLength)
                                        .offset(x: -ttLength / 2.0, y: proxy.size.height / 2.0 - ttLength / 2.0)
                                    }
                                }
                            } else if (skipColumns.contains(mod(col, 12))) {
                            } else {
                                KeyContainer(model: model,
                                             keyboardCell: KeyboardCell(row: row, col: col, pitch: Pitch(intValue: midi)),
                                             pitch: Pitch(intValue: midi),
                                             content: content)
                            }
                        } else {
                            Rectangle()
                                .fill(.clear)
                        }
                    }
                }
            }
        }
        .clipShape(Rectangle())
    }
}
