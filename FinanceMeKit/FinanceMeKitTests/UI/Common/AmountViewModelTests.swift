import XCTest
@testable import FinanceMeKit

final class AmountViewModelTests: XCTestCase {
    func testDefault() {
        let viewModel1 = AmountViewModel(value: 1200.34)

        XCTAssertEqual(viewModel1.sign, "")
        XCTAssertEqual(viewModel1.currencySymbol, "£")
        XCTAssertEqual(viewModel1.integer, "1,200")
        XCTAssertEqual(viewModel1.decimalSeparator, ".")
        XCTAssertEqual(viewModel1.fraction, "34")
        XCTAssertEqual(viewModel1.string, "£1,200.34")
        XCTAssertEqual(viewModel1.integerString, "1,200")

        let viewModel2 = AmountViewModel(value: -1200.34)

        XCTAssertEqual(viewModel2.sign, "-")
        XCTAssertEqual(viewModel2.currencySymbol, "£")
        XCTAssertEqual(viewModel2.integer, "1,200")
        XCTAssertEqual(viewModel2.decimalSeparator, ".")
        XCTAssertEqual(viewModel2.fraction, "34")
        XCTAssertEqual(viewModel2.string, "-£1,200.34")
        XCTAssertEqual(viewModel2.integerString, "-1,200")

        let viewModel3 = AmountViewModel(value: -10000.67)

        XCTAssertEqual(viewModel3.sign, "-")
        XCTAssertEqual(viewModel3.currencySymbol, "£")
        XCTAssertEqual(viewModel3.integer, "10,000")
        XCTAssertEqual(viewModel3.decimalSeparator, ".")
        XCTAssertEqual(viewModel3.fraction, "67")
        XCTAssertEqual(viewModel3.string, "-£10,000.67")
        XCTAssertEqual(viewModel3.integerString, "-10,000")
    }

    func testWithPlusMinusSign() {
        let viewModel1 = AmountViewModel(value: 12.34, signs: [.plus, .minus])

        XCTAssertEqual(viewModel1.sign, "+")
        XCTAssertEqual(viewModel1.currencySymbol, "£")
        XCTAssertEqual(viewModel1.integer, "12")
        XCTAssertEqual(viewModel1.decimalSeparator, ".")
        XCTAssertEqual(viewModel1.fraction, "34")
        XCTAssertEqual(viewModel1.string, "+£12.34")
        XCTAssertEqual(viewModel1.integerString, "+12")

        let viewModel2 = AmountViewModel(value: -12.34, signs: [.plus, .minus])

        XCTAssertEqual(viewModel2.sign, "-")
        XCTAssertEqual(viewModel2.currencySymbol, "£")
        XCTAssertEqual(viewModel2.integer, "12")
        XCTAssertEqual(viewModel2.decimalSeparator, ".")
        XCTAssertEqual(viewModel2.fraction, "34")
        XCTAssertEqual(viewModel2.string, "-£12.34")
        XCTAssertEqual(viewModel2.integerString, "-12")
    }

    func testWithNoSign() {
        let viewModel1 = AmountViewModel(value: 12.34, signs: [])

        XCTAssertEqual(viewModel1.sign, "")
        XCTAssertEqual(viewModel1.currencySymbol, "£")
        XCTAssertEqual(viewModel1.integer, "12")
        XCTAssertEqual(viewModel1.decimalSeparator, ".")
        XCTAssertEqual(viewModel1.fraction, "34")
        XCTAssertEqual(viewModel1.string, "£12.34")
        XCTAssertEqual(viewModel1.integerString, "12")

        let viewModel2 = AmountViewModel(value: -12.34, signs: [])

        XCTAssertEqual(viewModel2.sign, "")
        XCTAssertEqual(viewModel2.currencySymbol, "£")
        XCTAssertEqual(viewModel2.integer, "12")
        XCTAssertEqual(viewModel2.decimalSeparator, ".")
        XCTAssertEqual(viewModel2.fraction, "34")
        XCTAssertEqual(viewModel2.string, "£12.34")
        XCTAssertEqual(viewModel1.integerString, "12")
    }
}
