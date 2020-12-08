//
//  InAppPurchaseClass.swift
//  SuperMindSkill
//
//  Created by Pritam on 10/03/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit
import StoreKit

class InAppPurchaseClass: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    // MAKE this class to a single tone class 
    static var share = InAppPurchaseClass()
    let productArray: Set = Set(["Met.SuperMindSkill.SevenDaysTrial","Met.SuperMindSkill.non_Renewable.TwelveMonthSubscribe"])
    var prices:[String] = []
    var products: [String: SKProduct] = [:]
    fileprivate var restoreProductComplition: ((Bool,String)->Void)?
    //MARK: Fetch all ptoducts by id
    // function is star point to fetch all product from appstore
    
    
    func fetchProducts() {
        let productIDs = productArray
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
        
    }
    func restorePurchase(complition: @escaping ((Bool,String)->Void)){
        self.restoreProductComplition = complition
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if let complition = self.restoreProductComplition {
            complition(true, "")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print(error.localizedDescription)
        if let complition = self.restoreProductComplition {
            complition(false, error.localizedDescription)
        }
    }
    func purchase(productID: String) {
        if SKPaymentQueue.canMakePayments() {
            if let product = products[productID] {
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(payment)
                SKPaymentQueue.default().add(self)
            }
        }
    }
    func givePiceDetails() -> [String]{
        return self.prices
    }
    
    //MARK: - SK ProductsRequestDelegate method -
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        response.invalidProductIdentifiers.forEach { ids in
            print(ids)
        }
        //save product as a dictionary with product id as a key
        response.products.forEach { product in
            print("Valid: \(product)")
            products[product.productIdentifier] = product
            let price = "\(product.priceLocale.currencySymbol ?? "")\(product.price)"
            prices.append(price)
            //NotificationCenter.default.post(name: "Reload", object: nil)
            
            
        }
        // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Reload"), object: nil, userInfo: nil)
        
    }
    
    
    //MARK: - Fail with error
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Request %@ failed on attempt with error: %@", request, error.localizedDescription)
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("Product purchase done")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    NotificationCenter.default.post(name: .purchaseSuccess, object: nil)
                    break
                    
                case .failed:
                    // print("Product purchase failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    NotificationCenter.default.post(name: .purchaseFail, object: nil)
                    break
                    
                case .restored:
                    print("Product restored")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default: break
                }}}
    }
    
}

