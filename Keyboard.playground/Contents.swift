import Keyboard
import PlaygroundSupport
import SwiftUI
import Tonic

struct ContentView: View {
    var body: some View {
        Keyboard()
        Keyboard(layout: .grid)
        Keyboard(pitchRange: Pitch(0) ... Pitch(60 + 37))
    }
}

PlaygroundPage.current.setLiveView(ContentView())
