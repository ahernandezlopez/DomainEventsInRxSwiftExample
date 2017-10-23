import Foundation
import RxSwift
import UIKit

public class ListingListViewController: BaseViewController {
    private let contentView: ListingListView
    private let service: ListingService
    private var visibleDisposeBag: DisposeBag
    
    public init(service: ListingService,
                title: String) {
        self.contentView = ListingListView()
        self.service = service
        self.visibleDisposeBag = DisposeBag()
        super.init()
        self.title = title
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        contentView.frame = view.frame
        view.addSubview(contentView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(create))
        
        let params = ListingServiceSearchParams()
        service.search(params: params) { [weak self] result in
            guard let listings = result.data else { return }
            self?.contentView.listings = listings
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentView.deselectSelectedRow()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
        
        service.events.subscribe(onNext: { [weak self] event in
            guard let `self` = self else { return }
            switch event {
            case let .create(listing):
                self.contentView.create(listing: listing)
            case let .update(listing):
                self.contentView.update(listing: listing)
            case let .delete(listing):
                self.contentView.delete(listing: listing)
            }
        }, onError: { error in
            print("onError: \(error)")
        }, onCompleted: {
            print("onCompleted")
        }, onDisposed: {
            print("onDisposed")
        }).disposed(by: disposeBag)
        
        contentView.selectedListing.subscribe(onNext: { [weak self] listing in
            guard let `self` = self,
                  let listing = listing else { return }
            let viewController = ListingDetailViewController(service: self.service,
                                                             listing: listing)
            self.navigationController?.pushViewController(viewController, animated: true)
        }, onError: { error in
            print("onError: \(error)")
        }, onCompleted: {
            print("onCompleted")
        }, onDisposed: {
            print("onDisposed")
        }).disposed(by: disposeBag)
    }
    
    @objc private dynamic func create() {
        let params = ListingServiceCreateParams(title: String.makeRandom(length: 10),
                                                price: Int.makeRandom())
        service.create(params: params,
                       completion: nil)
    }
}
