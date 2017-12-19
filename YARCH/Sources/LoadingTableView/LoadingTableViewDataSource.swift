import UIKit

/// DataSource для состояния загрузки таблицы
extension LoadingTableViewDataSource {
    struct Configuration {
        var numberOfSection = 1
        var numberOfRowsInSection = 100
    }
}

class LoadingTableViewDataSource: NSObject, UITableViewDataSource {
    let appearance: Configuration

    init(appearance: Configuration = Configuration()) {
        self.appearance = appearance
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return appearance.numberOfSection
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appearance.numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithRegistration(type: LoadingTableViewCell.self, indexPath: indexPath)
    }
}
