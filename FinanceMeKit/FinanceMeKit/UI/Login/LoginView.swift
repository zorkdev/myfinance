import SwiftUI

public struct LoginView: View {
    @ObservedObject private var viewModel: LoginViewModel

    public var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Email", text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $viewModel.password)
                        .textContentType(.password)
                }
                Section {
                    Button(action: viewModel.onTap) {
                        Text("Login")
                    }
                    .disabled(viewModel.isDisabled)
                }
            }
            .navigationBarTitle("Login")
        }
    }

    public init(appState: AppState) {
        self.viewModel = LoginViewModel(businessLogic: appState.sessionBusinessLogic)
    }
}

struct LoginViewPreviews: PreviewProvider {
    static var previews: some View {
        LoginView(appState: AppState.stub)
            .previewLayout(.sizeThatFits)
    }
}