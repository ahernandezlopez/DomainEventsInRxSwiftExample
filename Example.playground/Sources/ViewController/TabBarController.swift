import Foundation
import UIKit

public class TabBarController: UITabBarController {
    private let repository: ListingRepository
    
    public init(repository: ListingRepository) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)

        let tab1 = UINavigationController(rootViewController: ListingListViewController(repository: repository,
                                                                                        title: "1️⃣"))
        let tab2 = UINavigationController(rootViewController: ListingListViewController(repository: repository,
                                                                                        title: "2️⃣"))
        let tab3 = UINavigationController(rootViewController: ListingListViewController(repository: repository,
                                                                                        title: "3️⃣"))
        let viewControllers = [tab1, tab2, tab3]
        viewControllers.forEach { $0.navigationBar.isTranslucent = false }
        self.viewControllers = viewControllers
        
        for viewController in viewControllers {
            let tabBarItem = UITabBarItem(title: viewController.title,
                                          image: nil,
                                          selectedImage: nil)
            tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -15)
            viewController.tabBarItem = tabBarItem
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
