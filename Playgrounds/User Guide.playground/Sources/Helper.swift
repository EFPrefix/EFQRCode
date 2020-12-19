public extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return [String](repeating: lhs, count: rhs).joined()
    }
}
