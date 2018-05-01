public struct CellModelWrapper: Hashable {

    public let wrapped: CellModelType

    public var hashValue: Int {
        return ObjectIdentifier(wrapped).hashValue
    }

    public init(_ cellModelType: CellModelType) {
        self.wrapped = cellModelType
    }

    public static func == (lhs: CellModelWrapper, rhs: CellModelWrapper) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

}

public protocol CellModelType: class {

    static var reuseIdentifier: String { get }

    var wrap: CellModelWrapper { get }

}

public extension CellModelType {

    var wrap: CellModelWrapper {
        return CellModelWrapper(self)
    }

}