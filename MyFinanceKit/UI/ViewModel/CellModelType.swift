public protocol Identifiable {
    var id: Int { get }
}

public struct CellModelWrapper: Hashable {
    public let wrapped: CellModelType

    public init(_ cellModelType: CellModelType) {
        self.wrapped = cellModelType
    }

    public static func == (lhs: CellModelWrapper, rhs: CellModelWrapper) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrapped.id)
    }
}

public protocol CellModelType: AnyObject, Identifiable {
    static var reuseIdentifier: String { get }
    static var rowHeight: CGFloat { get }

    var wrap: CellModelWrapper { get }
    var canEdit: Bool { get }
}

public extension CellModelType {
    static var rowHeight: CGFloat { return 60 }

    var wrap: CellModelWrapper {
        return CellModelWrapper(self)
    }

    var canEdit: Bool { return false }
}
