import RxSwift

public struct ListingRepositorySearchParams {
    public init() {
    }
}

public struct ListingRepositoryCreateParams {
    let title: String
    let price: Int
    
    public init(title: String,
                price: Int) {
        self.title = title
        self.price = price
    }
}

public struct ListingRepositoryUpdateParams {
    let title: String?
    let price: Int?
    
    public init(title: String?,
                price: Int?) {
        self.title = title
        self.price = price
    }
}

public enum ListingRepositoryFetchError: Error {
    case notFound
}

public enum ListingRepositorySearchError: Error {
    
}

public enum ListingRepositoryCreateError: Error {
  
}

public enum ListingRepositoryUpdateError: Error {
    
}

public enum ListingRepositoryDeleteError: Error {
    
}

public protocol ListingRepository: class {
    var events: Observable<ListingRepositoryEvent> { get }
    func filteredEvents(listing: Listing) -> Observable<ListingRepositoryEvent>
    func filteredEvents(listings: [Listing]) -> Observable<ListingRepositoryEvent>
    
    func fetch(id: String,
               completion: ((Result<Listing, ListingRepositoryFetchError>) -> ())?)
    func search(params: ListingRepositorySearchParams,
                completion: ((Result<[Listing], ListingRepositorySearchError>) -> ())?)
    func create(params: ListingRepositoryCreateParams,
                completion: ((Result<Listing, ListingRepositoryCreateError>) -> ())?)
    func update(listing: Listing,
                params: ListingRepositoryUpdateParams,
                completion: ((Result<Listing, ListingRepositoryUpdateError>) -> ())?)
    func delete(listing: Listing,
                completion: ((Result<Listing, ListingRepositoryDeleteError>) -> ())?)
}
