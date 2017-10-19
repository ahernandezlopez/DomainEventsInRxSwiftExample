import Foundation
import RxSwift
import UIKit

public class BaseViewController: UIViewController {
    private var didFirstAppear: Bool
    let disposeBag: DisposeBag
    
    public init() {
        self.didFirstAppear = false
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !didFirstAppear {
            viewWillFirstAppear()
            didFirstAppear = true
        }
    }
    
    func viewWillFirstAppear() {
    }
}
