// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI
@_exported import Tonic

/// Touch-oriented musical keyboard
public struct Keyboard<Content>: View where Content: View {
    
    public enum HomeyLayout: Int, Equatable, CaseIterable {
        case grid = 1
        case linear = 2
        case piano = 3
        case guitar = 4
    }

    let content: (KeyboardCell, Pitch, Bool) -> Content
    
    @StateObject var model: KeyboardModel = .init()
    
    var latching: Bool
    var noteOn: (Pitch, CGPoint) -> Void
    var noteOff: (Pitch) -> Void
    var layout: KeyboardLayout
    
    /// Initialize the keyboard
    /// - Parameters:
    ///   - layout: The geometry of the keys
    ///   - latching: Latched keys stay on until they are pressed again
    ///   - noteOn: Closure to perform when a key is pressed
    ///   - noteOff: Closure to perform when a note ends
    ///   - content: View defining how to render a specific key
    public init(layout: KeyboardLayout,
                latching: Bool = false,
                noteOn: @escaping (Pitch, CGPoint) -> Void = { _, _ in },
                noteOff: @escaping (Pitch) -> Void = { _ in },
                @ViewBuilder content: @escaping (KeyboardCell, Pitch, Bool) -> Content)
    {
        self.latching = latching
        self.layout = layout
        self.noteOn = noteOn
        self.noteOff = noteOff
        self.content = content
    }
    
    /// Body enclosing the various layout views
    public var body: some View {
        ZStack {
            switch layout {
            case let .dualistic(octaveShift, octaveCount, keysPerRow, tonicPitchClass, upwardPitchMovement, initialC):
                Dualistic(content: content,
                          model: model,
                          octaveShift: octaveShift,
                          octaveCount: octaveCount,
                          keysPerRow: keysPerRow,
                          tonicPitchClass: tonicPitchClass,
                          upwardPitchMovement: upwardPitchMovement,
                          initialC: initialC)
            case let .grid(octaveShift, octaveCount, keysPerRow, tonicPitchClass, upwardPitchMovement, initialC):
                Grid(content: content,
                     model: model,
                     octaveShift: octaveShift,
                     octaveCount: octaveCount,
                     keysPerRow: keysPerRow,
                     tonicPitchClass: tonicPitchClass,
                     upwardPitchMovement: upwardPitchMovement,
                     initialC: initialC)
            }
            
            if !latching {
                MultitouchView { touches in
                    model.touchLocations = touches
                }
            }
            
        }.onPreferenceChange(KeyRectsKey.self) { keyRectInfos in
            model.keyRectInfos = keyRectInfos
        }.onAppear {
            model.noteOn = noteOn
            model.noteOff = noteOff
        }
    }
}

