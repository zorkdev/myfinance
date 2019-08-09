import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

// swiftlint:disable type_body_length
class DefaultNetworkServiceTests: XCTestCase {
    struct MockAPI: APIType {
        var url = URL(string: "https://www.apple.com")!

        func token(session: Session) -> String {
            session.token
        }
    }

    struct Body: Codable, Equatable {
        let body = "body"
    }

    var networkRequestable: MockNetworkRequestable!
    var loggingService: MockLoggingService!
    var sessionService: MockSessionService!
    var networkService: DefaultNetworkService!
    let api = MockAPI()
    let urlResponse = HTTPURLResponse(url: URL(string: "https://www.apple.com")!,
                                      statusCode: 200,
                                      httpVersion: nil,
                                      headerFields: nil)!

    override func setUp() {
        super.setUp()
        networkRequestable = MockNetworkRequestable()
        loggingService = MockLoggingService()
        sessionService = MockSessionService()
        networkService = DefaultNetworkService(networkRequestable: networkRequestable,
                                               loggingService: loggingService,
                                               sessionService: sessionService)
    }

    func testPerform_Success() {
        let session = Factory.makeSession()
        sessionService.session = session
        let data = Data()
        networkRequestable.performReturnValue = .success((data: data, response: urlResponse))

        networkService.perform(api: api, method: .get, body: nil).assertSuccess(self) { response in
            let request = self.networkRequestable.lastPerformParam!
            let headers = request.allHTTPHeaderFields!

            XCTAssertEqual(request.url, self.api.url)
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNil(request.httpBody)
            XCTAssertEqual(headers, ["Accept": "application/json",
                                     "Content-Type": "application/json",
                                     "Authorization": "Bearer \(session.token)"])

            XCTAssertEqual(response, data)

            XCTAssertNotNil(self.loggingService.lastLogParams)
        }
    }

    func testPerformWithBody_Success() {
        let session = Factory.makeSession()
        sessionService.session = session
        let data = Data()
        networkRequestable.performReturnValue = .success((data: data, response: urlResponse))
        let body = Body()
        let expectedBody =
            """
            {"body":"body"}
            """.data(using: .utf8)!

        networkService.perform(api: api, method: .post, body: body).assertSuccess(self) { response in
            let request = self.networkRequestable.lastPerformParam!
            let headers = request.allHTTPHeaderFields!

            XCTAssertEqual(request.url, self.api.url)
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.httpBody, expectedBody)
            XCTAssertEqual(headers, ["Accept": "application/json",
                                     "Content-Type": "application/json",
                                     "Authorization": "Bearer \(session.token)"])

            XCTAssertEqual(response, data)

            XCTAssertNotNil(self.loggingService.lastLogParams)
        }
    }

    func testPerformDecodable_Success() {
        let session = Factory.makeSession()
        sessionService.session = session
        let body = Body()
        networkRequestable.performReturnValue = .success((data: body.jsonEncoded().forceGet(), response: urlResponse))

        networkService.perform(api: api, method: .get, body: nil).assertSuccess(self) { (response: Body) in
            let request = self.networkRequestable.lastPerformParam!
            let headers = request.allHTTPHeaderFields!

            XCTAssertEqual(request.url, self.api.url)
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNil(request.httpBody)
            XCTAssertEqual(headers, ["Accept": "application/json",
                                     "Content-Type": "application/json",
                                     "Authorization": "Bearer \(session.token)"])

            XCTAssertEqual(response, body)

            XCTAssertNotNil(self.loggingService.lastLogParams)
        }
    }

    func testPerformURLError_Failure() {
        let expectedError = URLError(.badServerResponse)
        networkRequestable.performReturnValue = .failure(expectedError)

        networkService.perform(api: api, method: .get, body: nil).assertFailure(self) { error in
            let request = self.networkRequestable.lastPerformParam!
            let headers = request.allHTTPHeaderFields!

            XCTAssertEqual(request.url, self.api.url)
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNil(request.httpBody)
            XCTAssertEqual(headers, ["Accept": "application/json",
                                     "Content-Type": "application/json"])

            XCTAssertEqual(error as? URLError, expectedError)

            XCTAssertNotNil(self.loggingService.lastLogParams)
        }
    }

    func testPerformHTTPURLResponseError_Failure() {
        let expectedError = HTTPError(code: 1)!
        let urlResponse = URLResponse(url: api.url,
                                      mimeType: nil,
                                      expectedContentLength: 0,
                                      textEncodingName: nil)
        networkRequestable.performReturnValue = .success((data: Data(), response: urlResponse))

        networkService.perform(api: api, method: .get, body: nil).assertFailure(self) { error in
            XCTAssertNotNil(self.networkRequestable.lastPerformParam)
            XCTAssertNotNil(self.loggingService.lastLogParams)
            XCTAssertEqual(error as? HTTPError, expectedError)
        }
    }

    func testPerformHTTPError_Failure() {
        let expectedError = HTTPError(code: 400)!
        let urlResponse = HTTPURLResponse(url: api.url,
                                          statusCode: expectedError.code,
                                          httpVersion: nil,
                                          headerFields: nil)!
        networkRequestable.performReturnValue = .success((data: Data(), response: urlResponse))

        networkService.perform(api: api, method: .get, body: nil).assertFailure(self) { error in
            XCTAssertNotNil(self.networkRequestable.lastPerformParam)
            XCTAssertNotNil(self.loggingService.lastLogParams)
            XCTAssertEqual(error as? HTTPError, expectedError)
        }
    }

    func testPerformEncodingError_Failure() {
        networkService.perform(api: api, method: .post, body: Double.nan).assertFailure(self) { error in
            XCTAssertNil(self.networkRequestable.lastPerformParam)
            XCTAssertNil(self.loggingService.lastLogParams)
            XCTAssertTrue(error is EncodingError)
        }
    }

    func testPrintRequest() {
        let request = URLRequest(url: URL(string: "https://www.apple.com")!)

        let expectedValue =
            """
            GET https://www.apple.com
            --- Headers ---
            nil
            ---- Body -----
            nil
            """

        XCTAssertEqual(DefaultNetworkService.createRequestString(request), expectedValue)
    }

    func testPrintRequestJSON() {
        var request = URLRequest(url: URL(string: "https://www.apple.com")!)
        request.setValue("Value", forHTTPHeaderField: "Header")
        request.httpBody =
            """
            {"body":"body"}
            """.data(using: .utf8)!

        let expectedValue =
            """
            GET https://www.apple.com
            --- Headers ---
            {
              "Header" : "Value"
            }
            ---- Body -----
            {
              "body" : "body"
            }
            """

        XCTAssertEqual(DefaultNetworkService.createRequestString(request), expectedValue)
    }

    func testPrintDataResponse() {
        let data =
            """
            {
              "key" : "value"
            }
            """.data(using: .utf8)!

        let response = HTTPURLResponse(url: URL(string: "https://www.apple.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: ["Header": "Value"])!

        let expectedValue =
            """
            ----- URL -----
            https://www.apple.com
            --- Status ----
            200
            --- Headers ---
            {
              "Header" : "Value"
            }
            ---- Body -----
            {
              "key" : "value"
            }
            """

        XCTAssertEqual(DefaultNetworkService.createResponseString(data, response: response), expectedValue)
    }

    func testPrintErrorResponse() {
        let error = URLError(.notConnectedToInternet)

        let data =
            """
            {
              "key" : "value"
            }
            """.data(using: .utf8)!

        let response = HTTPURLResponse(url: URL(string: "https://ww.apple.com")!,
                                       statusCode: 500,
                                       httpVersion: nil,
                                       headerFields: ["Header": "Value"])!

        let expectedValue =
            """
            ----- URL -----
            https://ww.apple.com
            --- Status ----
            500
            --- Headers ---
            {
              "Header" : "Value"
            }
            ---- Error ----
            Error Domain=NSURLErrorDomain Code=-1009 "(null)"
            ---- Body -----
            {
              "key" : "value"
            }
            """

        XCTAssertEqual(DefaultNetworkService.createResponseString(error, data: data, response: response), expectedValue)
    }
}