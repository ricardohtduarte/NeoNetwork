import Foundation
import Combine
@testable import NeoNetwork

final class URLSessionMock: URLSessionProtocol {

    private(set) var dataTaskCalledCount = 0
    private(set) var dataTaskPublisherCalledCount = 0
    private(set) var dataCalledCount = 0

    var forcedDataTask: URLSessionDataTaskMock = .init()
    var forcedDataTaskPublisher: AnyPublisher = Just(Data()).setFailureType(to: Error.self).eraseToAnyPublisher()
    var forcedDataResult: Result<Data, Error> = .success(Data())

    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskMock {
        dataCalledCount += 1
        return forcedDataTask
    }

    func dataTaskPublisher(for url: URL) -> AnyPublisher<Data, Error> {
        dataTaskPublisherCalledCount += 1
        return forcedDataTaskPublisher
    }

    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        dataCalledCount += 1
        return try (forcedDataResult.get(), URLResponse())
    }
}

