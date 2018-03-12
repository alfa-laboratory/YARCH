// Протокол модели представления ячейки информации о криптовалюте

import Foundation

protocol CatalogDetailsCellRepresentable {
    var title: String { get }
    var subtitle: String { get }
}
