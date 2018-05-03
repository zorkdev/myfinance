struct CurrentMonthDisplayModel: TodayDisplayModelType {

    static let positiveColor = ColorPalette.green
    static let negativeColor = ColorPalette.red
    static let largeFontSize: CGFloat = 30
    static let smallFontSize: CGFloat = 16
    static let formatter = Formatters.currencyPlusMinusSign

    let forecast: NSAttributedString
    let spending: NSAttributedString
    let allowance: NSAttributedString

    init(currentMonthSummary: CurrentMonthSummary) {
        let createString = {
            CurrentMonthDisplayModel.amountAttributedString(from: CurrentMonthDisplayModel.formatter.string(from: $0))
        }

        forecast = createString(currentMonthSummary.forecast)
        spending = createString(currentMonthSummary.spending)
        allowance = createString(currentMonthSummary.allowance)
    }

}
