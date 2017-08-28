//
//  DBHelper.swift
//  MiniMart
//
//  Created by nitin muthyala on 28/8/17.
//  Copyright © 2017 Spaceage Labs. All rights reserved.
//

import Foundation

class DBHelper {
    
    static func fillDB(){
        // add items to db
    }
    
    
    static func getAllProducts() -> [Product]{
        let product1 = Product(id: "1", price: 4.50, name: "Nutella", description: "", image: nil)
        let product2 = Product(id: "2", price: 4.50, name: "Delfi", description: "", image: nil)
        
        return [product1,product2]
    }
    
    static func updateCart(productId:String,qty:Int) ->Bool{
        
        return true
    }
    
    static func clearCart() ->Bool{
        
        return true
    }
    
    static func removeFromCart(productId:String) ->Bool{
        
        return true
    }
    
    
}
