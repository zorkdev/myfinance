import SwiftUI

struct MonthlyBalanceView: View {
    private let monthlyBalance: RegularsViewModel.MonthlyBalance

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                AmountView(viewModel: AmountViewModel(value: monthlyBalance.allowance,
                                                      signs: [.plus, .minus]))
                    .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
                Text("ALLOWANCE").font(.caption).foregroundColor(Color.secondary)
            }
            .accessibilityElement(children: .combine)
            VStack(alignment: .trailing) {
                AmountView(viewModel: AmountViewModel(value: monthlyBalance.outgoings,
                                                      signs: [.plus, .minus]))
                    .frame(minWidth: .zero, maxWidth: .infinity, alignment: .trailing)
                Text("OUTGOINGS").font(.caption).foregroundColor(Color.secondary)
            }
            .accessibilityElement(children: .combine)
        }
        .padding([.top, .bottom])
    }

    init(monthlyBalance: RegularsViewModel.MonthlyBalance) {
        self.monthlyBalance = monthlyBalance
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct MonthlyBalanceViewPreviews: PreviewProvider {
    static var previews: some View {
        MonthlyBalanceView(monthlyBalance: RegularsViewModel.MonthlyBalance(allowance: 1233.56,
                                                                            outgoings: -2562.32))
            .previewLayout(.sizeThatFits)
    }
}
#endif
