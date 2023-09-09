// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI
import Tonic

public enum KeyType {
    case symbol
    case text
}

struct Home: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: 0.4*rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: 0.4*rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
    }
}

/// A default visual representation for a key.
public struct IntervallicKey: View {
    /// Initialize the keyboard key
    /// - Parameters:
    ///   - pitch: Pitch assigned to the key
    ///   - keyType: Symbol or text type key
    ///   - tonicPitchClass: The tonic pitch class
    ///   - isActivated: Whether to represent this key in the "down" state
    ///   - text: Label on the key
    ///   - color: Color of the activated key
    ///   - isActivatedExternally: Usually used for representing incoming MIDI
    public init(pitch: Pitch,
                keyType: KeyType,
                tonicPitchClass: Int,
                isActivated: Bool,
                tonicColor: Color,
                perfectColor: Color,
                majorColor: Color,
                minorColor: Color,
                tritoneColor: Color,
                keyColor: Color,
                tonicKeyColor: Color,
                flatTop: Bool = false,
                alignment: Alignment = .center,
                isActivatedExternally: Bool = false)
    {
        self.pitch = pitch
        self.keyType = keyType
        self.tonicPitchClass = tonicPitchClass
        self.isActivated = isActivated
        self.flatTop = flatTop
        self.alignment = alignment
        self.isActivatedExternally = isActivatedExternally
        
        self.pitchClass = (pitch.intValue - tonicPitchClass) % 12
        switch self.pitchClass {
        case 0:
            self.iconColor = tonicColor
            self.homeIcon = true
            self.keyColor = tonicKeyColor
        case 5, 7:
            self.iconColor = perfectColor
            self.homeIcon = true
            self.keyColor = keyColor
        case 2, 4, 9, 11:
            self.iconColor = majorColor
            self.homeIcon = false
            self.keyColor = keyColor
        case 1, 3, 8, 10:
            self.iconColor = minorColor
            self.homeIcon = false
            self.keyColor = keyColor
        case 6:
            self.iconColor = tritoneColor
            self.homeIcon = false
            self.keyColor = keyColor
        default:
            self.iconColor = Color.black
            self.homeIcon = false
            self.keyColor = Color.white
        }
    }

    var pitch: Pitch
    var keyType: KeyType
    var tonicPitchClass: Int
    var isActivated: Bool
    var flatTop: Bool
    var alignment: Alignment
    var isActivatedExternally: Bool
    var keyColor: Color
    var iconColor: Color
    var homeIcon: Bool
    let pitchClass: Int
    
    func minDimension(_ size: CGSize) -> CGFloat {
        return min(size.width, size.height)
    }

    func isTall(size: CGSize) -> Bool {
        size.height > size.width
    }

    // How much of the key height to take up with label
    func relativeFontSize(in containerSize: CGSize) -> CGFloat {
        minDimension(containerSize) * 0.333
    }

    let relativeTextPadding = 0.05

    func relativeCornerRadius(in containerSize: CGSize) -> CGFloat {
        minDimension(containerSize) * 0.125
    }

    func topPadding(_ size: CGSize) -> CGFloat {
        flatTop && alignment == .bottom ? relativeCornerRadius(in: size) : 0
    }

    func leadingPadding(_ size: CGSize) -> CGFloat {
        flatTop && alignment == .trailing ? relativeCornerRadius(in: size) : 0
    }

    func negativeTopPadding(_ size: CGSize) -> CGFloat {
        flatTop && alignment == .bottom ? -relativeCornerRadius(in: size) : 0.5
    }

    func negativeLeadingPadding(_ size: CGSize) -> CGFloat {
        flatTop && alignment == .trailing ? -relativeCornerRadius(in: size) : 0.5
    }

    func enharmonicDescription(_ pitchClass: Int) -> String {
        switch pitchClass {
        case 0:
            return NoteClass.C.description
        case 1:
            return "\(NoteClass.Cs.description) \(NoteClass.Db.description)"
        case 2:
            return NoteClass.D.description
        case 3:
            return "\(NoteClass.Ds.description) \(NoteClass.Eb.description)"
        case 4:
            return NoteClass.E.description
        case 5:
            return NoteClass.F.description
        case 6:
            return "\(NoteClass.Fs.description) \(NoteClass.Gb.description)"
        case 7:
            return NoteClass.G.description
        case 8:
            return "\(NoteClass.Gs.description) \(NoteClass.Ab.description)"
        case 9:
            return NoteClass.A.description
        case 10:
            return "\(NoteClass.As.description) \(NoteClass.Bb.description)"
        case 11:
            return NoteClass.B.description
        default: return NoteClass.C.description
        }
    }
    
    public var body: some View {
        
        GeometryReader { proxy in
            ZStack(alignment: alignment) {
                Rectangle()
                    .foregroundColor(keyColor)
                    .padding(.top, topPadding(proxy.size))
                    .padding(.leading, leadingPadding(proxy.size))
                    .cornerRadius(relativeCornerRadius(in: proxy.size))
                    .padding(.top, negativeTopPadding(proxy.size))
                    .padding(.leading, negativeLeadingPadding(proxy.size))
                    .padding(.trailing, 0.5)
                if (self.keyType == .symbol) {
                    if (self.homeIcon) {
                        Home()
                            .stroke(self.iconColor, lineWidth: 2)
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: proxy.size.width*0.3, height: proxy.size.height*0.3)
                    } else {
                        Circle()
                            .foregroundColor(self.iconColor)
                            .frame(width: proxy.size.width*0.2, height: proxy.size.height*0.2)
                    }
                } else if (self.keyType == .text) {
                    Text(enharmonicDescription(self.pitchClass))
                        .foregroundColor(self.iconColor)
                        .padding(.leading, 2)
                        .padding(.trailing, 2)
                }
            }
        }
    }
}
