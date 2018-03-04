// Провайдер кэширования данных для отрисовки изображений

import UIKit

extension ImageProvider {
    enum Configuration {
        static let networkTimeout: TimeInterval = 30
    }
}

class ImageProvider {

    static let shared = ImageProvider()

    let urlSession: URLSession

    var baseUrl: String = "https://cryptocompare.com"

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func loadImageData(_ urlString: String, completion: @escaping((Data) -> Void)) {

        guard let url = URL(string: baseUrl + urlString) else { return completion(Data())  }

        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: Configuration.networkTimeout)

        urlSession.dataTask(with: urlRequest) { (data, _, error) in
            guard
                error == nil,
                let data = data
            else { return completion(Data()) }

            completion(data)

        }.resume()
    }
}
