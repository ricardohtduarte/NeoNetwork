import Foundation

public protocol URLSessionProtocol {
    associatedtype DataTaskType
    associatedtype DataTaskPublisherType

    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTaskType

    func dataTaskPublisher(for url: URL) -> DataTaskPublisherType

    @available(iOS 15.0, *)
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
