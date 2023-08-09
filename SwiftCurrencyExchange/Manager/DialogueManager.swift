import Foundation
import UIKit

class DialogueManager {
    typealias methodHandler1 = () -> Void
    typealias methodHandler2 = (_ confirmed: Bool) -> Void
    
    static func showError(viewController: UIViewController, message: String, okHandler: @escaping methodHandler1) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            okHandler()
        }))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            viewController.present(alert, animated: true)
        })
    }
    static func showInfo(viewController: UIViewController, message: String, okHandler: @escaping methodHandler1) {
        let alert = UIAlertController(title: "Notification", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            okHandler()
        }))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            viewController.present(alert, animated: true)
        })
    }
    static func showInfo(viewController: UIViewController, title: String, message: String, buttonTitle:String? = nil, okHandler: @escaping methodHandler1) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var btn = "Ok"
        if buttonTitle != nil {
            btn = buttonTitle!
        }
        alert.addAction(UIAlertAction(title: btn, style: .default, handler: { action in
            okHandler()
        }))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            viewController.present(alert, animated: true)
        })
    }
}
