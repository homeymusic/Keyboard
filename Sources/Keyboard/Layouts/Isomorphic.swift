// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI
import Tonic

struct Isomorphic<Content>: View where Content: View {
    let content: (Pitch, Bool, Int, Int) -> Content
    var model: KeyboardModel
    var pitchRange: ClosedRange<Pitch>
    var root: NoteClass
    var scale: Scale

    var pitchesToShow: [Pitch] {
        var pitchArray: [Pitch] = []
        let key = Key(root: root, scale: scale)
        for pitch in pitchRange where pitch.existsNaturally(in: key) {
            pitchArray.append(pitch)
        }
        return Array(pitchArray)
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(pitchesToShow, id: \.self) { pitch in
                KeyContainer(model: model,
                             pitch: pitch,
                             row: 0,
                             col: 0,
                             content: content)
            }
        }
        .clipShape(Rectangle())
    }
}
