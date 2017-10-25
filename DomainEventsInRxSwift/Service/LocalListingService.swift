import RxSwift

public class LocalListingService: ListingService {
    private var listings: [Listing]
    private var listingsMap: [String: Listing]
    public var events: Observable<ListingServiceEvent> {
        return eventsPublishSubject.asObservable()
    }
    private let eventsPublishSubject: PublishSubject<ListingServiceEvent>
    private let disposeBag: DisposeBag
    
    public init() {
        self.listings = []
        self.listingsMap = [:]
        self.eventsPublishSubject = PublishSubject<ListingServiceEvent>()
        self.disposeBag = DisposeBag()
        
        events.asObservable()
            .subscribe(onNext: { [weak self] event in
                self?.handle(event: event)
            }, onError: { error in
                print("onError: \(error)")
            }, onCompleted: {
                print("onCompleted")
            }, onDisposed: {
                print("onDisposed")
            }).disposed(by: disposeBag)
    }
    
    public func filteredEvents(listing: Listing) -> Observable<ListingServiceEvent> {
        return filteredEvents(listings: [listing])
    }
    
    public func filteredEvents(listings: [Listing]) -> Observable<ListingServiceEvent> {
        return events.filter { event in
            return listings.contains(where: { listing in
                return event.listing.id == listing.id
            })
        }
    }
    
    public func fetch(id: String,
                      completion: ((Result<Listing, ListingServiceFetchError>) -> ())?) {
        let result: Result<Listing, ListingServiceFetchError>
        if let listing = listingsMap[id] {
            result = .success(data: listing)
        } else {
            result = .failure(error: .notFound)
        }
        let deadline: DispatchTime = .now() + .milliseconds(50)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion?(result)
        }
    }
    
    public func search(params: ListingServiceSearchParams,
                       completion: ((Result<[Listing], ListingServiceSearchError>) -> ())?) {
        let result = Result<[Listing], ListingServiceSearchError>.success(data: listings)
        let deadline: DispatchTime = .now() + .milliseconds(50)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion?(result)
        }
    }
    
    public func create(params: ListingServiceCreateParams,
                       completion: ((Result<Listing, ListingServiceCreateError>) -> ())?) {
        let listing = Listing(id: String.makeRandom(length: 5),
                              title: params.title,
                              price: params.price)
        let result = Result<Listing, ListingServiceCreateError>.success(data: listing)
        let deadline: DispatchTime = .now() + .milliseconds(50)
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            defer { completion?(result) }
            self?.eventsPublishSubject.onNext(ListingServiceEvent.create(listing: listing))
        }
    }
    
    public func update(listing: Listing,
                       params: ListingServiceUpdateParams,
                       completion: ((Result<Listing, ListingServiceUpdateError>) -> ())?) {
        let updatedListing = Listing(id: listing.id,
                                     title: params.title ?? listing.title,
                                     price: params.price ?? listing.price)
        let result = Result<Listing, ListingServiceUpdateError>.success(data: updatedListing)
        let deadline: DispatchTime = .now() + .milliseconds(50)
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            defer { completion?(result) }
            self?.eventsPublishSubject.onNext(ListingServiceEvent.update(listing: updatedListing))
        }
    }
    
    public func delete(listing: Listing,
                       completion: ((Result<Listing, ListingServiceDeleteError>) -> ())?) {
        let result = Result<Listing, ListingServiceDeleteError>.success(data: listing)
        let deadline: DispatchTime = .now() + .milliseconds(50)
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            defer { completion?(result) }
            self?.eventsPublishSubject.onNext(ListingServiceEvent.delete(listing: listing))
        }
    }
    
    private func handle(event: ListingServiceEvent) {
        switch event {
        case let .create(listing):
            self.listings.append(listing)
            self.listingsMap[listing.id] = listing
        case let .delete(listing):
            if let index = indexFor(listing: listing) {
                self.listings.remove(at: index)
            }
            self.listingsMap[listing.id] = nil
        case let .update(listing):
            if let index = indexFor(listing: listing) {
                self.listings.replaceSubrange(index...index, with: [listing])
            }
            self.listingsMap[listing.id] = listing
        }
    }
    
    private func indexFor(listing: Listing) -> Int? {
        return listings.index(where: { $0.id == listing.id })
    }
}
