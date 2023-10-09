// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI
import Tonic

/// Types of keyboards we can generate
public enum KeyboardLayout: Equatable, Hashable {
    case dualistic(octaveCount: Int, keysPerRow: Int, tonicPitchClass: Int, initialC: Int)
}
