//
//  DBHelper.swift
//  MiniMart
//
//  Created by nitin muthyala on 28/8/17.
//  Copyright © 2017 Spaceage Labs. All rights reserved.
//

import Foundation
import SQLite

class DBHelper {
    
    static let instance = DBHelper()
    private let db: Connection?
    
    
    // Product
    private let product = Table("product")
    private let id = Expression<String>("id")
    private let name = Expression<String>("name")
    private let description = Expression<String>("description")
    private let price = Expression<Double>("price")
    private let image = Expression<Blob?>("image")
    
    // Cart Item
    private let cartItem = Table("cartItem")
    private let productId = Expression<String>("productId")
    private let quantity = Expression<Int>("quantity")
    
    
    private init() {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else{
            db = nil
            print ("Path fail")
            return
        }
        print(path)
        do {
            db = try Connection("\(path)/MiniMart.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        createTable()
    }
    
    
    func createTable() {
        do {
            
            // Product
            try db!.run(product.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(description)
                table.column(price)
                table.column(image)
            })
            
            // CartItem
            try db!.run(cartItem.create(ifNotExists: true) { table in
                table.column(productId, primaryKey: true)
                table.column(quantity)
            })
            
        } catch {
            print("Unable to create table")
        }
    }
    
    // MARK:- Product
    
    func getAllProducts() -> [Product]{

        
        var products = [Product]()
        
        do {
            for product in try db!.prepare(self.product) {
                var data : Data? = nil
                if let bytes = product[image]?.bytes{
                    data = Data(bytes:bytes)
                }
                
                products.append(Product(id: product[id], price: product[price], name: product[name], description: product[description], image: data))
            }
        } catch {
            print("Select failed")
        }
        
        return products
    }
    
    
    
    
    func getProduct(cid:String) ->Product?{
        var foundProduct : Product?
        
        do {
            
            let cproduct = self.product.filter(id == cid)
            for product in try db!.prepare(cproduct) {
                var data : Data? = nil
                if let bytes = product[image]?.bytes{
                    data = Data(bytes:bytes)
                }
                foundProduct = Product(id: product[id], price: product[price], name: product[name], description: product[description], image: data)
                
            }
        } catch {
            print("Select failed")
        }
        
        return foundProduct
    }
    
    
    
    // MARK:- Cart
    
    func getCartQty(cproductId:String) ->Int{
        var foundQty : Int = 0
        
        do {
            
            let cItem = self.cartItem.filter(id == cproductId)
            for item in try db!.prepare(cItem) {
                
                foundQty = item[quantity]
            }
        } catch {
            print("Select failed")
        }
        
        return foundQty
    }
    
    
    func getCart() -> [CartItem]{

        var cartItems : [CartItem] = []
        
        do {
            
            let cItem = self.cartItem.filter(quantity > 0)
            for item in try db!.prepare(cItem) {
                
                let cartPId = item[productId]
                let cartQty = item[quantity]
                cartItems.append(CartItem(productId: cartPId, quantity: cartQty))
            }
        } catch {
            print("Select failed")
        }
        
        return cartItems
    }
    
    func updateCart(pId:String,qty:Int) ->Bool{
        
        let cItem = self.cartItem.filter(productId == pId)
        
        do {
            
            // if 0 then remove
            if qty == 0 {
                try db!.run(cItem.delete())
                return true
            }
            
            // If exist then update
            let update = cItem.update([productId <- pId, quantity <- qty])
            if try db!.run(update) > 0 {
                return true
            }
            
            // If it doesn exits then delete
            let insert = cartItem.insert(productId <- pId, quantity <- qty)
            try db!.run(insert)
            return true
        } catch {
            print("Update failed \(error)")
            return false
        }
    }
    
    
    // MARK:- Demo code
    func fillDB(){
        // add items to db
        if getAllProducts().count > 0 {
            return
        }
        
        let product1 = Product(id: "1", price: 4.50, name: "Nutella", description: "", image: UIImagePNGRepresentation(#imageLiteral(resourceName: "item")))
        let product2 = Product(id: "2", price: 6.90, name: "Apple", description: "", image: UIImagePNGRepresentation(#imageLiteral(resourceName: "apple")))
        let product3 = Product(id: "3", price: 1.80, name: "Coke", description: "", image: UIImagePNGRepresentation(#imageLiteral(resourceName: "can")))
        let product4 = Product(id: "4", price: 2.00, name: "Carrot", description: "", image: UIImagePNGRepresentation(#imageLiteral(resourceName: "carrot")))
        let product5 = Product(id: "5", price: 3.50, name: "Chilli", description: "", image: UIImagePNGRepresentation(#imageLiteral(resourceName: "chili")))
        let product6 = Product(id: "6", price: 14.50, name: "Doughnut", description: "", image: UIImagePNGRepresentation(#imageLiteral(resourceName: "doughnut")))
        let product7 = Product(id: "7", price: 5.00, name: "Fries", description: "", image: UIImagePNGRepresentation(#imageLiteral(resourceName: "fries")))
        let product8 = Product(id: "8", price: 14.00, name: "Steak", description: "", image: UIImagePNGRepresentation(#imageLiteral(resourceName: "steak")))
        
        let products = [product1,product2,product3,product4,product5,product6,product7,product8]
        
        for item in products{
            do {
                // Convert to blob
                var blob : Blob?
                if let image = item.image?.bytes{
                    blob = Blob(bytes: image)
                }
                
                // Insert
                let insert = product.insert(id <- item.id ,name <- item.name , description <- item.description , price <- item.price , image <- blob )
                try db!.run(insert)
                print("added items to db")
            } catch {
                continue
            }
        }
        
        
        
    }
    
    
}


