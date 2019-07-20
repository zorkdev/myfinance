public struct Payday: Equatable {
    public let intValue: Int
    public var stringValue: String { return "\(intValue)" }

    public init(intValue: Int) {
        self.intValue = intValue
    }
}

extension Payday: Describable {
    public var description: String { return stringValue }
}

public enum Paydays {
    private static let range = 1...28

    public static let values = range.map { Payday(intValue: $0) }
}
