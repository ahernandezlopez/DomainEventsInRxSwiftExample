//: Please build the scheme 'DomainEventsInRxSwift' first
import PlaygroundSupport
import RxSwift

PlaygroundPage.current.needsIndefiniteExecution = true

let repository: ListingRepository = LocalListingRepository()
PlaygroundPage.current.liveView = TabBarController(repository: repository)
