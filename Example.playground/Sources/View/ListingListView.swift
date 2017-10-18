import RxSwift
import UIKit

class ListingListView: UIView, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    var listings: [Listing] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var selectedListing: Observable<Listing?> {
        return selectedListingVar.asObservable()
    }
    private let selectedListingVar = Variable<Listing?>(nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        addSubview(tableView)
        
        var views = [String: Any]()
        views["tableView"] = tableView
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tableView]-0-|",
                                                      options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[tableView]-0-|",
                                                      options: [], metrics: nil, views: views))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func create(listing: Listing) {
        tableView.beginUpdates()
        defer { tableView.endUpdates() }
        
        listings.append(listing)
        guard let indexPath = indexPathFor(listing: listing) else { return }
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func update(listing: Listing) {
        guard let indexPath = indexPathFor(listing: listing) else { return }
        listings[indexPath.row] = listing
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func delete(listing: Listing) {
        tableView.beginUpdates()
        defer { tableView.endUpdates() }
        
        guard let indexPath = indexPathFor(listing: listing) else { return }
        listings.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func deselectSelectedRow() {
        guard let listing = selectedListingVar.value,
              let indexPath = indexPathFor(listing: listing) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
        let listing = listings[indexPath.row]
        cell.textLabel?.text = "\(listing.title) - $\(listing.price)"
        cell.detailTextLabel?.text = listing.id
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedListingVar.value = listings[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedListingVar.value = nil
    }
    
    private func indexPathFor(listing: Listing) -> IndexPath? {
        guard let row = listings.index(where: { $0.id == listing.id }) else { return nil }
        return IndexPath(row: row, section: 0)
    }
}
