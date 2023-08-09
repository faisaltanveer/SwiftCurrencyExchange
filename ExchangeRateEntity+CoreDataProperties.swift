//
//  ExchangeRateEntity+CoreDataProperties.swift
//  SwiftCurrencyExchange
//
//  Created by Innovative Saudia on 09/08/2023.
//
//

import Foundation
import CoreData


extension ExchangeRateEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExchangeRateEntity> {
        return NSFetchRequest<ExchangeRateEntity>(entityName: "ExchangeRateEntity")
    }

    @NSManaged public var currencyCode: String?
    @NSManaged public var rate: Double

}

extension ExchangeRateEntity : Identifiable {

}
