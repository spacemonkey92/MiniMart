//
//  ProductsViewModel.swift
//  MiniMart
//
//  Created by nitin muthyala on 28/8/17.
//  Copyright © 2017 Spaceage Labs. All rights reserved.
//

import Foundation
import RxSwift

/// Represent the view model of MartViewController

class MartViewModle{
    
    var products: Set<ProductViewModel> = [] // Assume fixed list of products
    let cartCount: Variable<Int> = Variable(0)
    var currency : CURRENCY = CURRENCY.SGD
    
    
    init(currency:CURRENCY) {
        let allProducts = DBHelper.instance.getAllProducts()
        let cartItems = DBHelper.instance.getCart()
        
        for product in allProducts {
            // Check if in cart
            let model = ProductViewModel(product: product, currency: currency)
            for cartItem in cartItems {
                if model.product.id == cartItem.productId{
                    model.cartQuantity.value = cartItem.quantity
                }
            }
            products.insert(model)
            
        }
        cartCount.value = cartItems.count
    }
    
    
    
    /// Added 1 quantity of a product to the cart
    ///
    /// - Parameter product: product
    func add(product:ProductViewModel){
        guard let index = products.index(of: product) else{
            return
        }
        let productVewModel = products[index]
        
        // Update the product
        if DBHelper.instance.updateCart(pId: productVewModel.product.id, qty: productVewModel.cartQuantity.value + 1){
            productVewModel.add()
            cartCount.value = cartCount.value + 1
        }
    }
    
    
    
    /// Removed 1 quantity of a product from the cart
    ///
    /// - Parameter product: product
    func remove(product:ProductViewModel){
        guard let index = products.index(of: product) else{
            return
        }
        let productVewModel = products[index]
        
        // Check if the qty is not 0
        if productVewModel.cartQuantity.value < 1 {
            return
        }
        
        // Update the product
        if DBHelper.instance.updateCart(pId: productVewModel.product.id, qty: productVewModel.cartQuantity.value - 1){
            productVewModel.remove()
            let count = cartCount.value - 1
            if count >= 0 { cartCount.value = count}
        }
    }
    
    
    
    
    
    
}
