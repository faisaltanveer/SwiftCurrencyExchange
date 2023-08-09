
import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let persistentContainer = NSPersistentContainer(name: "CurrencyExchangeData")
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        if let viewController = window?.rootViewController as? CurrencyConversionViewController {
            viewController.managedObjectContext = persistentContainer.viewContext
        }
        return true
    }
}

