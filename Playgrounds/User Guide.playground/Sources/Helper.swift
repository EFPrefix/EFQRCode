public extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return [String](repeating: lhs, count: rhs).joined()
    }
}

import PlaygroundSupport

import EFQRCode

extension EFIntSize: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return cgSize
    }
}
