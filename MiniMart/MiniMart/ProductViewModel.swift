//
//  ProductViewModel.swift
//  MiniMart
//
//  Created by nitin muthyala on 28/8/17.
//  Copyright © 2017 Spaceage Labs. All rights reserved.
//

import Foundation
import RxSwift



/// This ViewModel of the product type reuseable in both "CartView" and "MartView"

/// All products are equatable

class ProductViewModel : Equatable, Hashable {
    
    let product : Product
    let cartQuantity : Variable<Int> = Variable(0)
    
    init(product:Product) {
        self.product = product
    }
    
    func add(){
        let newQty = self.cartQuantity.value + 1
        self.cartQuantity.value = newQty
    }
    
    func remove(){
        let current = self.cartQuantity.value
        if current < 1 {
            return
        }
        self.cartQuantity.value = self.cartQuantity.value - 1
    }
    
    func getPrice() -> Double{
        return product.price * Double(cartQuantity.value)
    }
    
    func getPricePretty() -> String {
        let price = String(format: "%.2f", getPrice())
        return "$\(price)"
    }
    
    func getPriceDetails() ->String{
        return "\(cartQuantity.value) x \(getPricePretty())"
    }
    
    func getProductPricePretty() -> String {
        let price = String(format: "%.2f", product.price)
        return "$\(price)"
    }

    
    
    var hashValue: Int {
        get {
            return product.hashValue
        }
    }
    
}

func ==(lhs: ProductViewModel, rhs: ProductViewModel) -> Bool {
    return lhs.product == rhs.product
}
