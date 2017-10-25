import Foundation
import RxSwift
import UIKit

public class ListingDetailViewController: BaseViewController {
    private let contentView: ListingDetailView
    private let service: ListingService
    private var listing: Listing
    
    public init(service: ListingService,
                listing: Listing) {
        self.contentView = ListingDetailView()
        self.service = service
        self.listing = listing
        super.init()
        title = listing.id
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        contentView.frame = view.frame
        view.addSubview(contentView)
        updateUI()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(update))
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
        
        service.events.subscribe(onNext: { [weak self] event in
            self?.listing = event.listing
            self?.updateUI()
        }, onError: { error in
            print("onError: \(error)")
        }, onCompleted: {
            print("onCompleted")
        }, onDisposed: {
            print("onDisposed")
        }).disposed(by: disposeBag)
    }
    
    private func updateUI() {
        contentView.setLabels(id: listing.id,
                              title: listing.title,
                              price: String(listing.price))
    }
    
    @objc private dynamic func update() {
        let params = ListingServiceUpdateParams(title: String.makeRandom(length: 10),
                                                price: Int.makeRandom())
        service.update(listing: listing,
                       params: params,
                       completion: nil)
    }
}
