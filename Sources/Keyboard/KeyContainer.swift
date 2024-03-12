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
        self.zIndex = zIndex
        self.content = content
    }
    
    func rect(rect: CGRect) -> some View {
        let isPitchOn = model.touchedKeyboardCells.map {
            return $0.pitch
        }.contains(pitch)
        let isExternalPitchOn = model.externallyActivatedKeyboardCells.map {
            return $0.pitch
        }.contains(pitch)
        return content(keyboardCell, pitch, isPitchOn || isExternalPitchOn)
            .contentShape(Rectangle()) // Added to improve tap/click reliability
            .gesture(
                TapGesture().onEnded { _ in
                    if model.externallyActivatedKeyboardCells.contains(keyboardCell) {
                        model.externallyActivatedKeyboardCells.remove(keyboardCell)
                    } else {
                        model.externallyActivatedKeyboardCells.insert(keyboardCell)
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
