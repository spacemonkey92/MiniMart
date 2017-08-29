//
//  CartItemCell.swift
//  MiniMart
//
//  Created by nitin muthyala on 29/8/17.
//  Copyright © 2017 Spaceage Labs. All rights reserved.
//

import UIKit
import RxSwift

class CartItemCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var priceDetails: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    
    //Rx Swift
    let disposeBag = DisposeBag()
    var viewModel: ProductViewModel? {
        didSet {
            bindData()
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Border
        self.mainView.layer.cornerRadius = 6
        self.mainView.layer.borderWidth = 0.5
        self.mainView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func bindData(){
        guard let viewModel = self.viewModel else{
            return
        }
        
        self.priceDetails.text = viewModel.getPriceDetails()
        self.productName.text = viewModel.product.name
        
    }
    
}
