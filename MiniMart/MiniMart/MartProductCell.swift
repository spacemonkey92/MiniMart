//
//  MartProductCell.swift
//  MiniMart
//
//  Created by nitin muthyala on 28/8/17.
//  Copyright © 2017 Spaceage Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class MartProductCell : UICollectionViewCell{
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reduceButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cartCount: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var buttonsView: UIView!
    
    let disposeBag = DisposeBag()
    var viewModel: ProductViewModel? {
        didSet {
            bindData()
        }
    }
    
    
    override func awakeFromNib() {
        buttonsView.applyGradient()
        self.mainView.layer.cornerRadius = 6
        self.mainView.layer.borderWidth = 0.5
        self.mainView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    
    func bindData(){
        guard let viewModel = self.viewModel else{
            return
        }
        
        viewModel.cartQuantity.asObservable()
            .subscribe(onNext: { qty in
                if qty == 0 {
                    self.reduceButton.isHidden = true
                    self.addButton.isHidden = true
                    self.cartCount.setTitle("ADD TO CART", for: .normal)
                }else{
                    self.reduceButton.isHidden = false
                    self.addButton.isHidden = false
                    self.cartCount.setTitle(String(qty), for: .normal)
                }
                
            })
            .addDisposableTo(disposeBag)
        self.productNameLabel.text = viewModel.product.name
        self.priceLabel.text = viewModel.getProductPricePretty()
        if let data = viewModel.product.image{
            self.productImage.image =  UIImage(data:data,scale:1.0)
        }
        
    }
    
    
}
