typealias UniqueIdentifier = String

/// Протокол определяющий поведение объектов идентфицируемых уникально
protocol UniqueIdentifiable {
	var uid: UniqueIdentifier { get }
}
