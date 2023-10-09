// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI
import Tonic

/// This handles the interaction for key, so the user can provide their own
/// visual representation.
struct KeyContainer<Content: View>: View {
    let content: (KeyboardCell, Pitch, Bool) -> Content

    @ObservedObject var model: KeyboardModel
    
    let keyboardCell: KeyboardCell
    let pitch: Pitch
    
    var zIndex: Int

    init(model: KeyboardModel,
         keyboardCell: KeyboardCell,
         pitch: Pitch,
         zIndex: Int = 0,
         @ViewBuilder content: @escaping (KeyboardCell, Pitch, Bool) -> Content)
    {
        self.model = model
        self.keyboardCell = keyboardCell
        self.pitch = pitch
        print("self.keyboardCell \(self.keyboardCell)")
        self.zIndex = zIndex
        self.content = content
    }

    func rect(rect: CGRect) -> some View {
        content(keyboardCell, pitch, model.touchedPitches.contains(pitch) || model.externallyActivatedPitches.contains(pitch))
            .contentShape(Rectangle()) // Added to improve tap/click reliability
            .gesture(
                TapGesture().onEnded { _ in
                    if model.externallyActivatedPitches.contains(pitch) {
                        model.externallyActivatedPitches.remove(pitch)
                    } else {
                        model.externallyActivatedPitches.add(pitch)
                    }
                }
            )
            .preference(key: KeyRectsKey.self,
                        value: [KeyRectInfo(rect: rect,
                                            keyboardCell: keyboardCell,
                                            pitch: pitch,
                                            zIndex: zIndex)])
    }

    public var body: some View {
        GeometryReader { proxy in
            rect(rect: proxy.frame(in: .global))
        }
    }
}
