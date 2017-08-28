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

class MartViewModle : NSObject{
    
    var products: Set<ProductViewModel> = [] // Assume fixed list of products
    let cartCount: Variable<Int> = Variable(0)
    
    
    
    override init() {
        let allProducts = DBHelper.getAllProducts()
        for product in allProducts {
            products.insert(ProductViewModel(product: product))
        }
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
        if DBHelper.updateCart(productId: productVewModel.product.id, qty: productVewModel.cartQuantity.value + 1){
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
        if DBHelper.updateCart(productId: productVewModel.product.id, qty: productVewModel.cartQuantity.value - 1){
            productVewModel.remove()
            cartCount.value = cartCount.value - 1
        }
    }
    
    
    
    
    
    
}
