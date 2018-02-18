import ClockKit
import MyFinanceKit

class ComplicationController: NSObject, CLKComplicationDataSource {

    func getSupportedTimeTravelDirections(
        for complication: CLKComplication,
        withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }

    func getTimelineStartDate(for complication: CLKComplication,
                              withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }

    func getTimelineEndDate(for complication: CLKComplication,
                            withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }

    func getPrivacyBehavior(for complication: CLKComplication,
                            withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.hideOnLockScreen)
    }

    func getCurrentTimelineEntry(for complication: CLKComplication,
                                 withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        guard let dataService = (WKExtension.shared().delegate as? ExtensionDelegate)?.appState.dataService else {
            handler(nil)
            return
        }

        let allowance = Allowance.load(dataService: dataService)?.formatted ?? ""

        switch complication.family {
        case .utilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            template.textProvider = CLKSimpleTextProvider(text: allowance)
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(),
                                                             complicationTemplate: template)
            handler(timelineEntry)
        case .utilitarianSmallFlat:
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            template.textProvider = CLKSimpleTextProvider(text: allowance)
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(),
                                                         complicationTemplate: template)
            handler(timelineEntry)
        default:
            handler(nil)
        }
    }

    func getTimelineEntries(for complication: CLKComplication,
                            before date: Date,
                            limit: Int,
                            withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        handler(nil)
    }

    func getTimelineEntries(for complication: CLKComplication,
                            after date: Date,
                            limit: Int,
                            withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        handler(nil)
    }

    func getLocalizableSampleTemplate(for complication: CLKComplication,
                                      withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        handler(nil)
    }

}
