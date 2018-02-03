import NotificationCenter

class TodayViewController: NSViewController {

    @IBOutlet private weak var balanceLabel: NSTextField!
    @IBOutlet private weak var allowanceLabel: NSTextField!

    private var viewModel: TodayViewModel!

    override var nibName: NSNib.Name? {
        return NSNib.Name(String(describing: TodayViewController.self))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = TodayViewModel(delegate: self, displayModel: TodayDisplayModel())
        viewModel.viewDidLoad()
    }

}

extension TodayViewController: TodayViewModelDelegate {

    func set(balance: NSAttributedString) {
        balanceLabel.attributedStringValue = balance
    }

    func set(allowance: NSAttributedString) {
        let allowanceTemp = NSMutableAttributedString(attributedString: allowance)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        allowanceTemp.addAttributes(
            [NSAttributedStringKey.paragraphStyle: paragraphStyle],
            range: NSRange(location: 0, length: allowance.length))
        allowanceLabel.attributedStringValue = allowanceTemp
    }

}

extension TodayViewController: NCWidgetProviding {

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        viewModel.updateData().then {
            completionHandler(.newData)
        }.catch { error in
            print(error)
            completionHandler(.failed)
        }
    }

}
