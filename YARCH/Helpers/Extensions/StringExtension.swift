import Foundation

extension String {
    func extractURLs() -> [URL] {
        var urls: [URL] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count), using: { (result, _, _) in
                guard
                    let match = result,
                    let url = match.url
                else { return }

                urls.append(url)
            })
        } catch let error {
            print(error.localizedDescription)
        }
        return urls
    }
}
