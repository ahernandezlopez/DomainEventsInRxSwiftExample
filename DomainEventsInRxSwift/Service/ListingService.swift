import RxSwift

public struct ListingServiceSearchParams {
    public init() {
    }
}

public struct ListingServiceCreateParams {
    let title: String
    let price: Int
    
    public init(title: String,
                price: Int) {
        self.title = title
        self.price = price
    }
}

public struct ListingServiceUpdateParams {
    let title: String?
    let price: Int?
    
    public init(title: String?,
                price: Int?) {
        self.title = title
        self.price = price
    }
}

public enum ListingServiceFetchError: Error {
    case notFound
}

public enum ListingServiceSearchError: Error {
    
}

public enum ListingServiceCreateError: Error {
  
}

public enum ListingServiceUpdateError: Error {
    
}

public enum ListingServiceDeleteError: Error {
    
}

public protocol ListingService: class {
    var events: Observable<ListingServiceEvent> { get }
    func filteredEvents(listing: Listing) -> Observable<ListingServiceEvent>
    func filteredEvents(listings: [Listing]) -> Observable<ListingServiceEvent>
    
    func fetch(id: String,
               completion: ((Result<Listing, ListingServiceFetchError>) -> ())?)
    func search(params: ListingServiceSearchParams,
                completion: ((Result<[Listing], ListingServiceSearchError>) -> ())?)
    func create(params: ListingServiceCreateParams,
                completion: ((Result<Listing, ListingServiceCreateError>) -> ())?)
    func update(listing: Listing,
                params: ListingServiceUpdateParams,
                completion: ((Result<Listing, ListingServiceUpdateError>) -> ())?)
    func delete(listing: Listing,
                completion: ((Result<Listing, ListingServiceDeleteError>) -> ())?)
}
