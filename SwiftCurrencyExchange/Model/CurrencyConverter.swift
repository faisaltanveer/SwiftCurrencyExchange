
import Foundation
import UIKit
import Alamofire

class CurrencyConverter {
    var exchangeRates: [ExchangeRate] = []
    
    func convertAmount(_ amount: Double, from sourceCurrency: String, to targetCurrency: String) -> Double {
        guard let sourceRate = exchangeRate(for: sourceCurrency),
              let targetRate = exchangeRate(for: targetCurrency) else {
            return 0.0
        }
        let convertedAmount = (amount / sourceRate) * targetRate
        return convertedAmount
    }
    private func exchangeRate(for currencyCode: String) -> Double? {
        return exchangeRates.first { $0.currencyCode == currencyCode }?.rate
    }
    func fetchExchangeRates(completion: @escaping () -> Void) {
        let apiKey = "b6314624665943e09e8a210c1d9d7392"
        let apiUrl = Constants.exchangeRatesApi + apiKey
        let headers = ["Content-Type":"application/json"]
        NetworkManager.shared.sendDataOnNetworkWithHeaders(apiName: apiUrl, parameters: [String : Any](), headers: headers, methodType: .post, view: UIView(frame: .zero)) { response in
            print("ex rates api response == \(response)")
            if let rates = response["rates"] as? [String: Double] {
                self.exchangeRates = rates.map { ExchangeRate(currencyCode: $0.key, rate: $0.value) }
                self.exchangeRates = self.exchangeRates.sorted { $0.currencyCode < $1.currencyCode }
            }
            completion()
        }
    }
}
