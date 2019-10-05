import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class AuthenticationBusinessLogicTests: XCTestCase {
    var authenticationService: MockAuthenticationService!
    var businessLogic: AuthenticationBusinessLogic!

    override func setUp() {
        super.setUp()
        authenticationService = MockAuthenticationService()
        businessLogic = AuthenticationBusinessLogic(authenticationService: authenticationService)
    }

    func testAuthentication_Success() {
        businessLogic.isAuthenticated.assertSuccess(self) { XCTAssertFalse($0) }

        authenticationService.authenticateReturnValue = .success(())

        businessLogic.willEnterForeground()

        waitForEvent {
            XCTAssertTrue(self.authenticationService.lastAuthenticateParam?.isEmpty == false)
        }

        businessLogic.isAuthenticated.assertSuccess(self) { XCTAssertTrue($0) }

        businessLogic.didEnterBackground()

        businessLogic.isAuthenticated.assertSuccess(self) { XCTAssertFalse($0) }
    }

    func testAuthentication_Failure() {
        businessLogic.isAuthenticated.assertSuccess(self) { XCTAssertFalse($0) }

        authenticationService.authenticateReturnValue = .failure(TestError())

        businessLogic.authenticate()

        waitForEvent {}

        businessLogic.isAuthenticated.assertSuccess(self) { XCTAssertFalse($0) }
    }

    func testStub() {
        let stub = Stub.StubAuthenticationBusinessLogic()
        stub.authenticate()
        stub.willEnterForeground()
        stub.didEnterBackground()
    }
}