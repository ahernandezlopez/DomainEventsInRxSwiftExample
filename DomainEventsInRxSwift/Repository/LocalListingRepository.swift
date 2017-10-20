import RxSwift

public class LocalListingRepository: ListingRepository {
    private var listings: [Listing]
    private var listingsMap: [String: Listing]
    public var events: Observable<ListingRepositoryEvent> {
        return eventsPublishSubject.asObservable()
    }
    private let eventsPublishSubject: PublishSubject<ListingRepositoryEvent>
    private let disposeBag: DisposeBag
    
    public init() {
        self.listings = []
        self.listingsMap = [:]
        self.eventsPublishSubject = PublishSubject<ListingRepositoryEvent>()
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
    
    public func filteredEvents(listing: Listing) -> Observable<ListingRepositoryEvent> {
        return filteredEvents(listings: [listing])
    }
    
    public func filteredEvents(listings: [Listing]) -> Observable<ListingRepositoryEvent> {
        return events.filter { event in
            return listings.contains(where: { listing in
                return event.listing.id == listing.id
            })
        }
    }
    
    public func fetch(id: String,
                      completion: ((Result<Listing, ListingRepositoryFetchError>) -> ())?) {
        let result: Result<Listing, ListingRepositoryFetchError>
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
    
    public func search(params: ListingRepositorySearchParams,
                       completion: ((Result<[Listing], ListingRepositorySearchError>) -> ())?) {
        let result = Result<[Listing], ListingRepositorySearchError>.success(data: listings)
        let deadline: DispatchTime = .now() + .milliseconds(50)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion?(result)
        }
    }
    
    public func create(params: ListingRepositoryCreateParams,
                       completion: ((Result<Listing, ListingRepositoryCreateError>) -> ())?) {
        let listing = Listing(id: String.makeRandom(length: 5),
                              title: params.title,
                              price: params.price)
        let result = Result<Listing, ListingRepositoryCreateError>.success(data: listing)
        let deadline: DispatchTime = .now() + .milliseconds(50)
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            defer { completion?(result) }
            self?.eventsPublishSubject.onNext(ListingRepositoryEvent.create(listing: listing))
        }
    }
    
    public func update(listing: Listing,
                       params: ListingRepositoryUpdateParams,
                       completion: ((Result<Listing, ListingRepositoryUpdateError>) -> ())?) {
        let updatedListing = Listing(id: listing.id,
                                     title: params.title ?? listing.title,
                                     price: params.price ?? listing.price)
        let result = Result<Listing, ListingRepositoryUpdateError>.success(data: updatedListing)
        let deadline: DispatchTime = .now() + .milliseconds(50)
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            defer { completion?(result) }
            self?.eventsPublishSubject.onNext(ListingRepositoryEvent.update(listing: updatedListing))
        }
    }
    
    public func delete(listing: Listing,
                       completion: ((Result<Listing, ListingRepositoryDeleteError>) -> ())?) {
        let result = Result<Listing, ListingRepositoryDeleteError>.success(data: listing)
        let deadline: DispatchTime = .now() + .milliseconds(50)
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            defer { completion?(result) }
            self?.eventsPublishSubject.onNext(ListingRepositoryEvent.delete(listing: listing))
        }
    }
    
    private func handle(event: ListingRepositoryEvent) {
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
