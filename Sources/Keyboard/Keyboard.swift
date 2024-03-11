// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI
@_exported import Tonic

/// Touch-oriented musical keyboard
public struct Keyboard<Content>: View where Content: View {
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
            case let .dualistic(octaveShift, octaveCount, keysPerRow, tonicPitchClass, initialC):
                Dualistic(content: content,
                          model: model,
                          octaveShift: octaveShift,
                          octaveCount: octaveCount,
                          keysPerRow: keysPerRow,
                          tonicPitchClass: tonicPitchClass,
                          initialC: initialC)
            case let .grid(octaveShift, octaveCount, keysPerRow, tonicPitchClass, initialC):
                Grid(content: content,
                     model: model,
                     octaveShift: octaveShift,
                     octaveCount: octaveCount,
                     keysPerRow: keysPerRow,
                     tonicPitchClass: tonicPitchClass,
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

public extension Keyboard where Content == KeyboardKey {
    /// Initialize the Keyboard with KeyboardKey as its content
    /// - Parameters:
    ///   - layout: The geometry of the keys
    ///   - latching: Latched keys stay on until they are pressed again
    ///   - noteOn: Closure to perform when a key is pressed
    ///   - noteOff: Closure to perform when a note ends
    init(layout: KeyboardLayout,
         latching: Bool = false,
         noteOn: @escaping (Pitch, CGPoint) -> Void = { _, _ in },
         noteOff: @escaping (Pitch) -> Void = { _ in })
    {
        self.layout = layout
        self.latching = latching
        self.noteOn = noteOn
        self.noteOff = noteOff
        
        var alignment: Alignment = .bottom
        
        let flatTop = false
        switch layout {
        case .dualistic:
            alignment = .bottom
        case .grid:
            alignment = .bottom
        }
        content = {
            KeyboardKey(
                keyboardCell: $0,
                pitch: $1,
                isActivated: $2,
                flatTop: flatTop,
                alignment: alignment
            )
        }
    }
}
