import UIKit

public class ListingDetailView: UIView {
    private let idLabel = UILabel()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(idLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(priceLabel)
        
        var views = [String: Any]()
        views["idLabel"] = idLabel
        views["titleLabel"] = titleLabel
        views["priceLabel"] = priceLabel
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[idLabel]-0-|",
                                                      options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[titleLabel]-0-|",
                                                      options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[priceLabel]-0-|",
                                                      options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[idLabel]-0-[titleLabel]-0-[priceLabel]-(>=0)-|",
                                                      options: [], metrics: nil, views: views))
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setLabels(id: String?,
                          title: String?,
                          price: String?) {
        idLabel.text = "Id: \t\t\(id ?? "")"
        titleLabel.text = "Title: \t\(title ?? "")"
        priceLabel.text = "Price: \t$\(price ?? "")"
    }
}
