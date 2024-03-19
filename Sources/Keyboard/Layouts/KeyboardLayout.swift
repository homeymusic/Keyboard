// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI
import Tonic

/// Types of keyboards we can generate
public enum KeyboardLayout: Equatable, Hashable {
    case dualistic(octaveShift: Int, octaveCount: Int, keysPerRow: Int, tonicPitchClass: Int, upwardPitchMovement: Bool, initialC: Int)
    case grid(octaveShift: Int, octaveCount: Int, keysPerRow: Int, tonicPitchClass: Int, upwardPitchMovement: Bool, initialC: Int)
}
