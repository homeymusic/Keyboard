public struct KeyboardCell {
    let row: Int
    let col: Int
    
    public init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
}

extension KeyboardCell: Equatable {
    public static func == (lhs: KeyboardCell, rhs: KeyboardCell) -> Bool {
        return
            lhs.row == rhs.row &&
            lhs.col == rhs.col
    }
}
