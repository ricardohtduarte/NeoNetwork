import Foundation
import Combine

public protocol NeoNetworkProtocol {
    func fetch<T: Decodable>(from url: URL) -> AnyPublisher<T, Error>
}

public final class NeoNetwork {
    private let urlSession: URLSessionProtocol
    private let decoder: JSONDecoder
    private let fetcherQueue: DispatchQueue

    public init(urlSession: URLSessionProtocol = URLSession.shared,
                decoder: JSONDecoder = .init(),
                fetcherQueue: DispatchQueue = .init(label: "Network Service Queue")) {
        self.urlSession = urlSession
        self.decoder = decoder
        self.fetcherQueue = fetcherQueue
    }
}

extension NeoNetwork: NeoNetworkProtocol {
    public func fetch<T: Decodable>(from url: URL) -> AnyPublisher<T, Error> {
        urlSession
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: decoder)
            .receive(on: fetcherQueue)
            .eraseToAnyPublisher()
    }

    public func fetch<T: Decodable>(from url: URL, completionHandler: @escaping (Result<T?, Error>) -> Void) {
        urlSession.dataTask(with: url, completionHandler: { data, urlResponse, error in
            if let error = error {
                completionHandler(.failure(error))
            }

            guard let data = data else {
                completionHandler(.success(nil))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(decodedData))
            } catch let error {
                completionHandler(.failure(error))
            }
        }).resume()
    }

    @available(iOS 15.0, *)
    public func fetch<T: Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await urlSession.data(from: url, delegate: nil)
        let decodedData = try decoder.decode(T.self, from: data)
        return decodedData
    }
}
