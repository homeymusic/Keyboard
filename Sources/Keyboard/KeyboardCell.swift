public struct KeyboardCell {
    let row: Int
    let col: Int
    public let pitch: Pitch
    
    public init(row: Int, col: Int, pitch: Pitch) {
        self.row = row
        self.col = col
        self.pitch = pitch
    }
}

extension KeyboardCell: Equatable, Hashable {
    public static func == (lhs: KeyboardCell, rhs: KeyboardCell) -> Bool {
        return
            lhs.row == rhs.row &&
            lhs.col == rhs.col
    }
    
    public func hash(into hasher: inout Hasher) {
           hasher.combine(row)
           hasher.combine(col)
    }
}
