import Foundation

protocol URLSessionProtocol {
    @available(macOS 10.15, *)
    func dataTaskPublisher(for url: URL) -> URLSession.DataTaskPublisher
}

extension URLSession: URLSessionProtocol {}
