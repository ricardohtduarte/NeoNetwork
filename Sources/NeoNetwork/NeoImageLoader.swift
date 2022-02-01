import Foundation
import Combine
import UIKit

public protocol NeoImageLoaderProtocol {
    func downloadImage(from url: URL, completionHandler: @escaping (Result<UIImage?, Error>) -> Void)
}

public class NeoImageLoader {
    static let shared = NeoImageLoader(responseQueue: .main, session: .shared)

    private var cachedImageForURL: [URL: UIImage] = .init()

    private let responseQueue: DispatchQueue
    private let session: URLSession

    init(responseQueue: DispatchQueue, session: URLSession) {
        self.responseQueue = responseQueue
        self.session = session
    }
}

extension NeoImageLoader: NeoImageLoaderProtocol {
    public func downloadImage(from url: URL, completionHandler: @escaping (Result<UIImage?, Error>) -> Void) {
        if let uiImageForURL = cachedImageForURL[url] {
            completionHandler(.success(uiImageForURL))
        }

        session.dataTask(with: url, completionHandler: { [weak self] data, urlResponse, error in
            if let error = error {
                completionHandler(.failure(error))
            }

            guard
                let data = data,
                let uiImage = UIImage(data: data)
            else {
                completionHandler(.success(nil))
                return
            }

            self?.cachedImageForURL[url] = uiImage
            completionHandler(.success(uiImage))
        })
    }
}
