import Foundation

public struct Validators {

    private static let amountCharacterSet: CharacterSet = {
        var decimalDigits = CharacterSet.decimalDigits
        decimalDigits.insert(".")
        return decimalDigits
    }()

    public static func validate(amount: String) -> Bool {
        let c = Formatters.currencySymbol
        return amount.range(of: "^(\(c)?0\\.?|\(c)?0\\.\\d{0,2}|\(c)?[1-9]\\d{0,6}|\(c)?[1-9]\\d{0,6}\\.\\d{0,2})$",
                            options: .regularExpression) != nil
    }

}