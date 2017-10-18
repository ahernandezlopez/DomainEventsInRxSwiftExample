public enum Result<T, E: Error> {
    case success(data: T)
    case failure(error: E)
    
    public var data: T? {
        switch self {
        case let .success(data):
            return data
        case .failure:
            return nil
        }
    }
    
    public var error: E? {
        switch self {
        case .success:
            return nil
        case let .failure(error):
            return error
        }
    }
}
