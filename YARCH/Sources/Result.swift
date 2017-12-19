/// Тип для представления результатов выполнения какой-либо операции
///
/// - success: успешный результат
/// - failure: ошибочный результат
enum Result<T> {
	case success(T)
	case failure(Error)
}
