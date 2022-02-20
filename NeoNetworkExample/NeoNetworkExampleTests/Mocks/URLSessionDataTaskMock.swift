import Foundation
@testable import NeoNetwork

final class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    private(set) var resumeCallCount: Int = 0
    private(set) var cancelCallCount: Int = 0

    var forcedResumeExecution: () -> Void = {}
    var forcedCancelExecution: () -> Void = {}

    func resume() {
        forcedResumeExecution()
    }

    func cancel() {
        forcedCancelExecution()
    }
}
