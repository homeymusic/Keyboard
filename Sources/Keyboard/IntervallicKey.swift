// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI
import Tonic

public enum LabelType {
    case symbol
    case text
}

public enum IntervalType {
    case perfect
    case consonant
    case dissonant
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

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
    }
}

/// A default visual representation for a key.
public struct IntervallicKey: View {
    /// Initialize the keyboard key
    /// - Parameters:
    ///   - pitch: Pitch assigned to the key
    ///   - labelType: Symbol or text type key
    ///   - tonicPitchClass: The tonic pitch class
    ///   - isActivated: Whether to represent this key in the "down" state
    ///   - text: Label on the key
    ///   - color: Color of the activated key
    ///   - isActivatedExternally: Usually used for representing incoming MIDI
    public init(pitch: Pitch,
                labelType: LabelType,
                showClassicalSelector: Bool,
                showHomeySelector: Bool,
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
        self.labelType = labelType
        self.tonicPitchClass = tonicPitchClass
        self.isActivated = isActivated
        self.flatTop = flatTop
        self.alignment = alignment
        self.isActivatedExternally = isActivatedExternally
        self.pitchClass = pitch.intValue % 12
        self.showClassicalSelector = showClassicalSelector
        self.showHomeySelector = showHomeySelector
        
        switch (pitch.intValue - tonicPitchClass) % 12 {
        case 0:
            self.iconColor = tonicColor
            self.intervalType = .perfect
            self.keyColor = tonicKeyColor
            self.homeKey = true
        case 5, 7:
            self.iconColor = perfectColor
            self.intervalType = .perfect
            self.keyColor = keyColor
            self.homeKey = false
        case 4, 9:
            self.iconColor = majorColor
            self.intervalType = .consonant
            self.keyColor = keyColor
            self.homeKey = false
        case 2, 11:
            self.iconColor = majorColor
            self.intervalType = .dissonant
            self.keyColor = keyColor
            self.homeKey = false
        case 3, 8:
            self.iconColor = minorColor
            self.intervalType = .consonant
            self.keyColor = keyColor
            self.homeKey = false
        case 1, 10:
            self.iconColor = minorColor
            self.intervalType = .dissonant
            self.keyColor = keyColor
            self.homeKey = false
        case 6:
            self.iconColor = tritoneColor
            self.intervalType = .dissonant
            self.keyColor = keyColor
            self.homeKey = false
        default:
            self.iconColor = Color.black
            self.intervalType = .dissonant
            self.keyColor = Color.white
            self.homeKey = false
        }
    }

    var pitch: Pitch
    var labelType: LabelType
    var tonicPitchClass: Int
    var isActivated: Bool
    var flatTop: Bool
    var alignment: Alignment
    var isActivatedExternally: Bool
    var keyColor: Color
    var iconColor: Color
    var intervalType: IntervalType
    let pitchClass: Int
    let homeKey: Bool
    let showHomeySelector: Bool
    let showClassicalSelector: Bool
    
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

    func classicalDescription(_ pitchClass: Int) -> String {
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
    
    func homeyDescription(_ pitchClass: Int) -> String {
        switch pitchClass {
        case 0:
            return "Aug"
        case 1:
            return "Sep"
        case 2:
            return "Oct"
        case 3:
            return "Nov"
        case 4:
            return "Dec"
        case 5:
            return "Jan"
        case 6:
            return "Feb"
        case 7:
            return "Mar"
        case 8:
            return "Apr"
        case 9:
            return "May"
        case 10:
            return "Jun"
        case 11:
            return "Jul"
        default: return ""
        }
    }
    
    public var body: some View {
        
        GeometryReader { proxy in
            ZStack {
                Rectangle().foregroundColor(.white)
                    .padding(.top, topPadding(proxy.size))
                    .padding(.leading, leadingPadding(proxy.size))
                    .cornerRadius(relativeCornerRadius(in: proxy.size))
                    .padding(.top, negativeTopPadding(proxy.size))
                    .padding(.leading, negativeLeadingPadding(proxy.size))
                    .padding(.trailing, 0.5)
                ZStack(alignment: alignment) {
                    Rectangle().foregroundColor(keyColor)
                        .padding(.top, topPadding(proxy.size))
                        .padding(.leading, leadingPadding(proxy.size))
                        .cornerRadius(relativeCornerRadius(in: proxy.size))
                        .padding(.top, negativeTopPadding(proxy.size))
                        .padding(.leading, negativeLeadingPadding(proxy.size))
                        .padding(.trailing, 0.5)
                    if (self.labelType == .symbol) {
                        
                        if self.intervalType == .perfect {
                            Home()
                                .stroke(self.iconColor, lineWidth: 2)
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(width: proxy.size.width*0.3)
                        } else if self.intervalType == .consonant {
                             Diamond()
                                .foregroundColor(self.iconColor)
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(width: proxy.size.width*0.25)
                        } else if self.intervalType == .dissonant {
                            Circle()
                                .foregroundColor(self.iconColor)
                                .frame(width: proxy.size.width*0.2)
                        }
                    } else if (self.labelType == .text) {
                        VStack {
                            if showClassicalSelector {
                                Text(classicalDescription(self.pitchClass))
                                    .font(.headline)
                                    .lineLimit(1)
                            }
                            if showHomeySelector {
                                Text(homeyDescription(self.pitchClass))
                                    .font(.custom("Monaco", size: 15))
                                    .textCase(.uppercase)
                                    .lineLimit(1)
                            }
                        }
                        .foregroundColor(self.iconColor)
                        .scaledToFit()
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .padding(3)
                    }
                }
                .brightness(((isActivated || isActivatedExternally) && self.labelType == .symbol) ? -0.05 : 0.0)
                .mask(
                    RadialGradient(colors: [.black.opacity(homeKey ? (((isActivated || isActivatedExternally) && self.labelType == .symbol) ? 0.2: 0.75) : 0.95), .black],
                                   center: (isActivated || isActivatedExternally && self.labelType == .symbol) ? .top : .bottom,
                                   startRadius: 0,
                                   endRadius: proxy.size.height * 0.5)
                )
            }
        }
    }
}
