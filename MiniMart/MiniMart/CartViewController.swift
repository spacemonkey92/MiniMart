//
//  CartViewController.swift
//  MiniMart
//
//  Created by nitin muthyala on 29/8/17.
//  Copyright © 2017 Spaceage Labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CartViewController: UIViewController {
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var checkOutBtn: UIButton!
    @IBOutlet weak var totalBtn: UIButton!

    
    // ViewModel
    var viewModel : CartViewModel! {
        didSet {
            bindData()
        }
    }
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CartViewModel()
        // Do any additional setup after loading the view.
        setupTableView()
    }
    
    
    // MARK:- Rx Swift binding
    func bindData(){
        viewModel.cartTotal.asObservable()
            .subscribe(onNext: { count in
                self.totalBtn.setTitle(self.viewModel.totalCostPretty(), for: .normal)
            })
            .addDisposableTo(disposeBag)
    }
    
    // MARK:- View Setups
    func setupTableView(){
        // Register cell
        let nibName = UINib(nibName: "CartItemCell", bundle:nil)
        self.cartTableView.register(nibName, forCellReuseIdentifier: "CartCell")
        
        // Rx Bind the list with table view
        
        viewModel.cartProducts.asObservable()
            .bind(to:cartTableView
                .rx
                .items(cellIdentifier: "CartCell", cellType: CartItemCell.self)) {
                    row, product, cell in
                    cell.viewModel = product
                    cell.removeBtn.tag = row
                    cell.removeBtn.addTarget(self, action: #selector(self.didClickRemove(_:)), for: .touchUpInside)
            }
            .addDisposableTo(disposeBag)
    }
    
    // MARK:- Actions
    
    func didClickRemove(_ sender:UIButton){
        let index = sender.tag
        let products = viewModel.cartProducts.value
        let selectedProduct = products[products.index(products.startIndex, offsetBy: index)]
        viewModel.remove(product: selectedProduct)
    }
    
    @IBAction func didClickCheckOut(_ sender: Any) {
    }
    @IBAction func didClickTotoal(_ sender: Any) {
    }
    @IBAction func didClickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
