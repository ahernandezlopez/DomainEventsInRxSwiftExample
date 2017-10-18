public enum ListingRepositoryEvent {
    case create(listing: Listing)
    case update(listing: Listing)
    case delete(listing: Listing)
    
    public var listing: Listing {
        switch self {
        case let .create(listing):
            return listing
        case let .update(listing):
            return listing
        case let .delete(listing):
            return listing
        }
    }
}
