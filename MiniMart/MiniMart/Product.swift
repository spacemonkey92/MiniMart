//
//  Product.swift
//  MiniMart
//
//  Created by nitin muthyala on 28/8/17.
//  Copyright © 2017 Spaceage Labs. All rights reserved.
//

import Foundation



//MARK: - Product

struct Product: Equatable {
    
    let id:String
    let price: Double
    let name: String
    let description: String
    let image : Data?
    
    func getPrice(_ currency :CURRENCY) -> Double{
        switch currency {
        case CURRENCY.SGD:
            return self.price
        case CURRENCY.USD:
            return self.price * 1.3
        }
    }
    
}

extension Product: Hashable {
    var hashValue: Int {
        return self.id.hashValue
    }
}

//MARK: - Equatable Protocol implementation

func ==(lhs: Product, rhs: Product) -> Bool {
    
    // We consider two products as equal if their "ID" is same
    return (lhs.id == rhs.id)
}


public enum CURRENCY {
    case SGD
    case USD
}
