//
//  SwiftCurrencyExchangeTests.swift
//  SwiftCurrencyExchangeTests
//
//  Created by Apple on 09/08/2023.
//

import XCTest
@testable import SwiftCurrencyExchange
import CoreData

final class SwiftCurrencyExchangeTests: XCTestCase {
    var viewModel: CurrencyConversionViewModel!
    var mockContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        mockContext = MockManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        viewModel = CurrencyConversionViewModel(managedObjectContext: mockContext)
    }
    override func tearDown() {
        viewModel = nil
        mockContext = nil
        super.tearDown()
    }
    func testCurrencyConversion() {
        viewModel.currencyConverter.fetchExchangeRates {
            let convertedAmount = self.viewModel.currencyConverter.convertAmount(100, from: "USD", to: "PKR")
            let expectedConvertedAmount = 28747.49
            XCTAssertEqual(convertedAmount, expectedConvertedAmount, accuracy: 0.01)
        }
    }
}
class MockManagedObjectContext: NSManagedObjectContext {
    
}
