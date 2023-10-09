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
            var newPitches = PitchSet()
            for location in touchLocations {
                var keyboardCell: KeyboardCell?
                var pitch: Pitch?
                var highestZindex = -1
                var normalizedPoint = CGPoint.zero
                for info in keyRectInfos where info.rect.contains(location) {
                    if keyboardCell == nil || info.zIndex > highestZindex {
                        keyboardCell = info.keyboardCell
                        highestZindex = info.zIndex
                        normalizedPoint = CGPoint(x: (location.x - info.rect.minX) / info.rect.width,
                                                  y: (location.y - info.rect.minY) / info.rect.height)
                    }
                    if pitch == nil || info.zIndex > highestZindex {
                        pitch = info.pitch
                    }
                }
                if let p = pitch {
                    newPitches.add(p)
                    if let k = keyboardCell {
                        newKeyboardCells.insert(k)
                        normalizedPoints[p.intValue] = normalizedPoint
                    }
                }
            }
            if touchedKeyboardCells != newKeyboardCells {
                touchedKeyboardCells = newKeyboardCells
            }
            if touchedPitches.array != newPitches.array {
                touchedPitches = newPitches
            }
        }
    }
    
    /// Either latched keys or keys active due to external MIDI events.
    @Published var externallyActivatedPitches = PitchSet() {
        willSet { triggerPitchEvents(from: externallyActivatedPitches, to: newValue) }
    }
    
    func triggerPitchEvents(from oldValue: PitchSet, to newValue: PitchSet) {
        let newPitches = newValue.subtracting(oldValue)
        let removedPitches = oldValue.subtracting(newValue)

        for pitch in removedPitches.array {
            noteOff(pitch)
        }

        for pitch in newPitches.array {
            noteOn(pitch, normalizedPoints[pitch.intValue])
        }
    }

    @Published var touchedPitches = PitchSet() {
        willSet { triggerPitchEvents(from: touchedPitches, to: newValue) }
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
            noteOff(keyboardCell.pitch)
        }

        for keyboardCell in newKeyboardCells {
            noteOn(keyboardCell.pitch, normalizedPoints[keyboardCell.pitch.intValue])
        }
    }
}
