// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI
import Tonic

class KeyboardModel: ObservableObject {
    var keyRectInfos: [KeyRectInfo] = []
    var noteOn: (Pitch, CGPoint) -> Void = { _, _ in }
    var noteOff: (Pitch) -> Void = { _ in }
    var normalizedPoints = Array(repeating: CGPoint.zero, count: 128)
    
    var touchLocations: [CGPoint] = [] {
        didSet {
            var newKeyboardCells = Set<KeyboardCell>()
            var pressedKeyboardCells = Set<KeyboardCell>()
            for location in touchLocations {
                var keyboardCell: KeyboardCell?
                var highestZindex = -1
                var normalizedPoint = CGPoint.zero
                for info in keyRectInfos where info.rect.contains(location) {
                    if keyboardCell == nil || info.zIndex > highestZindex {
                        keyboardCell = info.keyboardCell
                        highestZindex = info.zIndex
                        normalizedPoint = CGPoint(x: (location.x - info.rect.minX) / info.rect.width,
                                                  y: (location.y - info.rect.minY) / info.rect.height)
                    }
                }
                if let k = keyboardCell {
                    newKeyboardCells.insert(k)
                    pressedKeyboardCells.insert(k)
                    normalizedPoints[k.pitch.intValue] = normalizedPoint
                }
            }
            if touchedKeyboardCells != newKeyboardCells {
                touchedKeyboardCells = newKeyboardCells
            }
            print("pressedKeyboardCells", pressedKeyboardCells)
        }
    }
    
    @Published var touchedKeyboardCells = Set<KeyboardCell>() {
        willSet { triggerEvents(from: touchedKeyboardCells, to: newValue) }
    }
    
    /// Either latched keys or keys active due to external MIDI events.
    @Published var externallyActivatedKeyboardCells = Set<KeyboardCell>() {
        willSet { triggerEvents(from: externallyActivatedKeyboardCells, to: newValue) }
    }
    
    func triggerEvents(from oldValue: Set<KeyboardCell>, to newValue: Set<KeyboardCell>) {
        let newKeyboardCells = newValue.subtracting(oldValue)
        let removedKeyboardCells = oldValue.subtracting(newValue)
                
        for keyboardCell in removedKeyboardCells {
//            print("off keyboardCell:", keyboardCell)
            noteOff(keyboardCell.pitch)
        }
        for keyboardCell in newKeyboardCells {
//            print("on keyboardCell:", keyboardCell)
            noteOn(keyboardCell.pitch, normalizedPoints[keyboardCell.pitch.intValue])
        }
    }
}
