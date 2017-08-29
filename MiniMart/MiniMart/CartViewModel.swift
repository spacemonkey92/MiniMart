//
//  CartViewModel.swift
//  MiniMart
//
//  Created by nitin muthyala on 29/8/17.
//  Copyright © 2017 Spaceage Labs. All rights reserved.
//

import Foundation
import RxSwift

class CartViewModel : NSObject{
    
    let cartProducts : Variable<Set<ProductViewModel>> = Variable([])
    let cartTotal: Variable<Double> = Variable(0)
    
    override init() {
        
        let cartItems = DBHelper.instance.getCart()
        
        for cartItem in cartItems{
            if let product = DBHelper.instance.getProduct(cid: cartItem.productId){
                let productViewModel = ProductViewModel(product: product)
                productViewModel.cartQuantity.value = cartItem.quantity
                cartProducts.value.insert(productViewModel)
            }
        }
        
    }
    
    func totalCost() -> Double {
        return cartProducts.value.reduce(0) {
            runningTotal, product in
            return runningTotal + product.product.price
        }
    }
    
    func totalCostPretty() -> String{
        let price = String(format: "%.2f", totalCost())
        return "$\(price)"
    }
    
    
    func remove(product:ProductViewModel){
        
        // Update the product
        if DBHelper.instance.updateCart(pId: product.product.id, qty: 0){
            cartProducts.value.remove(product)
            cartTotal.value = totalCost()
        }
        
    }
    
    
    
}
