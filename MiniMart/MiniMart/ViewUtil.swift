//
//  ViewUtil.swift
//  MiniMart
//
//  Created by nitin muthyala on 28/8/17.
//  Copyright © 2017 Spaceage Labs. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    public func applyGradient(){
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        
        let color1 = UIColor(red: 132/255, green: 250/255, blue: 176/255, alpha: 1).cgColor
        let color2 = UIColor(red: 143/255, green: 211/255, blue: 244/255, alpha: 1).cgColor
        gradient.colors = [color1, color2]
        gradient.startPoint = .zero
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        self.backgroundColor = .clear
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}

//extension UIImage: Value {
//    public class var declaredDatatype: String {
//        return Blob.declaredDatatype
//    }
//    public class func fromDatatypeValue(blobValue: Blob) -> UIImage {
//        return UIImage(data: Data.fromDatatypeValue(blobValue))!
//    }
//    public var datatypeValue: Blob {
//        return UIImagePNGRepresentation(self)!.datatypeValue
//    }
//    
//}
