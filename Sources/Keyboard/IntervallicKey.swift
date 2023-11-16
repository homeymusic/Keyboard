// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Keyboard/

import SwiftUI
import Tonic

public enum LabelType {
    case symbol
    case text
}

public enum IntervalType {
    case tonic
    case perfect
    case consonant
    case dissonant
}

struct NitterHouse: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: 0.4*rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))  // the gable peak
            path.addLine(to: CGPoint(x: rect.maxX, y: 0.4*rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
    }
}

struct NitterTent: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY)) // the tent peak
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

func mod(_ a: Int, _ n: Int) -> Int {
    precondition(n > 0, "modulus must be positive")
    let r = a % n
    return r >= 0 ? r : r + n
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
    public init(keyboardCell: KeyboardCell,
                pitch: Pitch,
                isActivated: Bool,
                labelType: LabelType,
                initialC: Int,
                tonicPitchClass: Int,
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
        self.keyboardCell = keyboardCell
        self.pitch = pitch
        self.labelType = labelType
        self.tonicPitchClass = tonicPitchClass
        self.isActivated = isActivated
        self.flatTop = flatTop
        self.alignment = alignment
        self.isActivatedExternally = isActivatedExternally
        self.pitchClass = mod(self.pitch.intValue - tonicPitchClass, 12)
        self.initialC = initialC
        
        switch self.pitchClass {
        case 0:
            self.iconColor = tonicColor
            self.intervalType = .tonic
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
            self.iconColor = .black
            self.intervalType = .dissonant
            self.keyColor = .white
            self.homeKey = false
        }
    }
    
    var keyboardCell: KeyboardCell
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
    let initialC: Int
    
    public var inPrimaryZone: Bool = false
    
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
    
    func smallerDimension(for proxy: GeometryProxy) -> CGFloat {
        proxy.size.width <= proxy.size.height ? proxy.size.width : proxy.size.height
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
                    VStack {
                        if (self.labelType == .symbol) {
                            ZStack {
                                HStack(alignment: .center) {
                                    if self.intervalType == .tonic {
                                        NitterHouse()
                                            .stroke(self.iconColor, style: StrokeStyle(lineWidth: 3, lineJoin: .round))
                                            .aspectRatio(1.0, contentMode: .fit)
                                            .frame(width: smallerDimension(for: proxy)*0.35)
                                    } else if self.intervalType == .perfect {
                                        NitterTent()
                                            .stroke(self.iconColor, style: StrokeStyle(lineWidth: 2.5, lineJoin: .round))
                                            .aspectRatio(1.0, contentMode: .fit)
                                            .frame(width: smallerDimension(for: proxy)*0.275)
                                    } else if self.intervalType == .consonant {
                                        Diamond()
                                            .foregroundColor(self.iconColor)
                                            .aspectRatio(1.0, contentMode: .fit)
                                            .frame(width: smallerDimension(for: proxy)*0.25)
                                    } else if self.intervalType == .dissonant {
                                        Circle()
                                            .foregroundColor(self.iconColor)
                                            .frame(width: smallerDimension(for: proxy)*0.2)
                                    }
                                }
                            }
                        }
                    }
                }
                .brightness(((isActivated || isActivatedExternally) && self.labelType == .symbol) ? (homeKey ? -0.35 : -0.05): 0)
                .mask(
                    RadialGradient(colors: [.black.opacity(((isActivated || isActivatedExternally) && self.labelType == .symbol) ? (homeKey ? 0.7 : 0.9) : 0.95), .black],
                                   center: (isActivated || isActivatedExternally && self.labelType == .symbol) ? .top : .bottom,
                                   startRadius: 0,
                                   endRadius: proxy.size.height * 0.5)
                )
            }
        }
    }
}
