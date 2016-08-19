//
//  UpgradeManager.swift
//  IAPDemo
//
//  Created by Hesham Abd-Elmegid on 8/18/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import Foundation
import StoreKit

class UpgradeManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let sharedInstance = UpgradeManager()
    let productIdentifier = "com.careerfoundry.randomquotes.famouspeoplequotes"
    typealias SuccessHandler = (succeeded: Bool) -> (Void)
    var upgradeCompletionHandler: SuccessHandler?
    var restoreCompletionHandler: SuccessHandler?
    var priceCompletionHandler: ((price: Float) -> Void)?
    var famousQuotesProduct: SKProduct?
    
    func hasUpgraded() -> Bool {
        return false
    }
    
    func upgrade(success: SuccessHandler) {
        if let product = famousQuotesProduct {
            let payment = SKPayment(product: product)
            SKPaymentQueue.defaultQueue().addPayment(payment)
        }
    }
    
    func restorePurchases(success: SuccessHandler) {
        
    }
    
    func priceForUpgrade(success: (price: Float) -> Void) {
        print("WTF?!")
        priceCompletionHandler = success
        
        let identifiers: Set<String> = [productIdentifier]
        let request = SKProductsRequest(productIdentifiers: identifiers)
        request.delegate = self
        request.start()
    }
    
    // MARK: SKPaymentTransactionObserver
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .Purchased:
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                upgradeCompletionHandler?(succeeded: true)
            case .Restored:
                restoreCompletionHandler?(succeeded: true)
            case .Failed:
                upgradeCompletionHandler?(succeeded: true)
            default:
                return
            }
            
            SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        }
    }
    
    // MARK: SKProductsRequestDelegate
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        famousQuotesProduct = response.products.first
        
        if let price = famousQuotesProduct?.price {
            priceCompletionHandler?(price: Float(price))
        }
    }
}
