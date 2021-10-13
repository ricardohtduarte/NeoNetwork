
import Foundation
import Combine

@available(macOS 10.15, *)
public protocol NeoNetworkProtocol {
    func fetch<T: Codable>(from url: URL) -> AnyPublisher<T, Error>
}

final class NeoNetwork {
    private let urlSession: URLSessionProtocol
    private let decoder: JSONDecoder
    private let fetcherQueue: DispatchQueue
    
    init(urlSession: URLSessionProtocol = URLSession.shared,
         decoder: JSONDecoder = .init(),
         fetcherQueue: DispatchQueue = .init(label: "Network Service Queue")) {
        self.urlSession = urlSession
        self.decoder = decoder
        self.fetcherQueue = fetcherQueue
    }
}

extension NeoNetwork: NeoNetworkProtocol {
    @available(macOS 10.15, *)
    func fetch<T: Codable>(from url: URL) -> AnyPublisher<T, Error> {
        urlSession
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: decoder)
            .receive(on: fetcherQueue)
            .eraseToAnyPublisher()
    }
}
