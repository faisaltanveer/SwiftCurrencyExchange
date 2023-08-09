
import Foundation
import CoreData
import UIKit

class CurrencyConversionViewModel {
    var currencyConverter = CurrencyConverter()
    private var managedObjectContext: NSManagedObjectContext
    var sourceCurrencyIndex: Int = 0
    var amount: String = ""
    var resultText: String = ""
    var updateData : (() -> ()) = {}
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        fetchExchangeRates()
    }
    func saveExchangeRatesToCoreData(_ exchangeRates: [ExchangeRate]) {
        for rate in exchangeRates {
            let exchangeRateEntity = ExchangeRateEntity(context: managedObjectContext)
            exchangeRateEntity.currencyCode = rate.currencyCode
            exchangeRateEntity.rate = rate.rate
        }
        saveContext()
    }
    func fetchExchangeRatesFromCoreData() -> [ExchangeRate] {
        let fetchRequest: NSFetchRequest<ExchangeRateEntity> = ExchangeRateEntity.fetchRequest()
        do {
            let fetchedEntities = try managedObjectContext.fetch(fetchRequest)
            let exchangeRates = fetchedEntities.map { entity in
                return ExchangeRate(currencyCode: entity.currencyCode ?? "", rate: entity.rate)
            }
            return exchangeRates
        } catch {
            print("Core Data fetching error == \(error)")
            return []
        }
    }
    private func clearExistingExchangeRatesFromCoreData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ExchangeRateEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch {
            print("clearing existing data error == \(error)")
        }
    }
    private func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print("saving context error == \(error)")
            }
        }
    }
    func fetchExchangeRates() {
        
        currencyConverter.fetchExchangeRates {
            if self.currencyConverter.exchangeRates.count > 0 {
                self.clearExistingExchangeRatesFromCoreData()
                self.saveExchangeRatesToCoreData(self.currencyConverter.exchangeRates)
                self.updateData()
            }
            else{
                self.currencyConverter.exchangeRates = self.fetchExchangeRatesFromCoreData()
                if self.currencyConverter.exchangeRates.count > 0 {
                    self.updateData()
                }
                else{
                    let message = "Something went wrong! Please try again."
                    if let topVC = UIApplication.topViewController() {
                        DialogueManager.showError(viewController: topVC, message: message) {}
                    }
                }
            }
        }
    }
    
    func updateConversionResult(toIndex:Int) {
        guard let amount = Double(amount),
            let sourceCurrency = currencyAtIndex(sourceCurrencyIndex) else {
            return
        }
        resultText = ""
        if currencyConverter.exchangeRates.count > toIndex{
            let exchangeRate = currencyConverter.exchangeRates[toIndex]
            let convertedAmount = currencyConverter.convertAmount(amount, from: sourceCurrency.code, to: exchangeRate.currencyCode)
            let convertedAmountRounded = String(format: "%.3f", convertedAmount)
            resultText += "\(convertedAmountRounded) \(exchangeRate.currencyCode)"
        }
    }
    private func currencyAtIndex(_ index: Int) -> Currency? {
        return index >= 0 && index < currencyConverter.exchangeRates.count ?
            Currency(code: currencyConverter.exchangeRates[index].currencyCode, name: "") :
            nil
    }
}

