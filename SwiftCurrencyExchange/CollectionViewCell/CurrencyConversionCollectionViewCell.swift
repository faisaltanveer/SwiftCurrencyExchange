//
//  CurrencyConversionCollectionViewCell.swift
//  SwiftCurrencyExchange
//
//  Created by Innovative Saudia on 08/08/2023.
//

import UIKit

class CurrencyConversionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var currencyLabel:UILabel!
    @IBOutlet weak var amountLabel:UILabel!
    
    func convertCurrency(atIndex index:Int) {
        
    }
    func configureData(currencyItem:ExchangeRate, atIndex index:Int, currencyController:CurrencyConversionViewController) {
        self.currencyLabel.text = currencyItem.currencyCode
        //self.amountLabel.text = "\(round(currencyItem.rate))"
        currencyController.viewModel.sourceCurrencyIndex = currencyController.sourceCurrencyIndex
        currencyController.viewModel.amount = currencyController.amountTextField.text ?? ""
        currencyController.viewModel.updateConversionResult(toIndex: index)
        self.amountLabel.text = currencyController.viewModel.resultText
    }
}
