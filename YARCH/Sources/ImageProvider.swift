// Провайдер кэширования данных для отрисовки изображений

import UIKit

class ImageProvider {

    static let shared = ImageProvider()

    let urlSession: URLSession

    let imageCache = NSCache<NSString, NSData>()
    var baseUrl: String = "https://cryptocompare.com"

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func loadImageData(_ urlString: String, completion: @escaping((Data) -> Void)) {
        guard let url = URL(string: baseUrl + urlString) else { return completion(Data())  }

        if let cachedImageData = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImageData as Data)
            return
        }

        urlSession.dataTask(with: url, completionHandler: { (data, _, error) in
            guard
                error == nil,
                let data = data as NSData?
            else { return completion(Data()) }

            self.imageCache.setObject(data, forKey: urlString as NSString)
            completion(data as Data)

        }).resume()
    }
}
