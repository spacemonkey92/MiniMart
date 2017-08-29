//
//  ViewController.swift
//  MiniMart
//
//  Created by nitin muthyala on 27/8/17.
//  Copyright © 2017 Spaceage Labs. All rights reserved.
//

import UIKit
import RxSwift

class MartViewController: UIViewController  {

    /// Views
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var cartBtn: UIBarButtonItem!
    @IBOutlet weak var currencyBtn: UIBarButtonItem!
    
    /// Properties
    fileprivate let reuseIdentifier = "ProductCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 10, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate let itemsPerRow: CGFloat = 2
    
    
    // ViewModel
    var viewModel : MartViewModle? {
        didSet {
            bindData()
        }
    }
    let disposeBag = DisposeBag()
    var currency : CURRENCY = CURRENCY.SGD
    
    
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initialSetup()
    }
    
    
    func initialSetup(){
        viewModel = MartViewModle(currency: currency)
        setupColletionView()
    }
    
    
    
    // MARK:- Rx Swift binding
    func bindData(){
        viewModel?.cartCount.asObservable()
            .subscribe(onNext: { count in
                self.cartBtn.title = count == 0 ? "Cart" : "Cart (\(String(count)))"
            })
            .addDisposableTo(disposeBag)
    }
    
    
    // MARK:- View Setups
    func setupColletionView(){
        self.productsCollectionView.register(UINib(nibName: "MartProductCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.productsCollectionView.delegate = self
        self.productsCollectionView.dataSource = self
        self.productsCollectionView.alwaysBounceVertical = true
        self.productsCollectionView.reloadData()
    }
    
    // MARL:- Currency
    func didClickSwitchCrcy(){
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        
        let sgd: UIAlertAction = UIAlertAction(title: "SGD", style: .default){ action -> Void in
            self.currency = .SGD
            self.initialSetup()
            self.currencyBtn.title = "SGD"
        }
        let usd: UIAlertAction = UIAlertAction(title: "USD", style: .default){ action -> Void in
            self.currency = .USD
            self.initialSetup()
            self.currencyBtn.title = "USD"
        }
        
        let optionsMenu = UIAlertController(title: "Select Currency", message: nil, preferredStyle: .actionSheet)
        optionsMenu.addAction(sgd)
        optionsMenu.addAction(usd)
        optionsMenu.addAction(cancel)
        
        // Present the bottom sheet
        optionsMenu.popoverPresentationController?.sourceView = self.view
        optionsMenu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height, width: 1.0, height: 1.0)
        self.present(optionsMenu, animated: true, completion: nil)
    }
    

    // MARK:- Actions
    @IBAction func didClickCart(_ sender: Any) {
        performSegue(withIdentifier: "viewCartSegue", sender: nil)
    }

    @IBAction func didClickCurrency(_ sender: Any) {
        didClickSwitchCrcy()
    }

    
    // MARK:- Seguea
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewCartSegue" {
            let cartVC = (segue.destination as! UINavigationController).topViewController as! CartViewController
            cartVC.currency = self.currency
        }
    }

}

// MARK:- Collection View Methods
extension MartViewController:  UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.viewModel?.products.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! MartProductCell
        let products = viewModel!.products
        cell.viewModel = products[products.index(products.startIndex, offsetBy: indexPath.row)]
        
        // Add and remove methods
        cell.addButton.tag = indexPath.row
        cell.reduceButton.tag = indexPath.row
        cell.cartCount.tag = indexPath.row
        
        cell.addButton.addTarget(self, action: #selector(didClickAdd(_:)), for: .touchUpInside)
        cell.reduceButton.addTarget(self, action: #selector(didClickRemove(_:)), for: .touchUpInside)
        cell.cartCount.addTarget(self, action: #selector(didClickAdd(_:)), for: .touchUpInside)
        // Configure the cell
        return cell
    }
    
    
    
    
    // MARK:- Cell Actions
    func didClickAdd(_ sender:UIButton){
        let index = sender.tag
        let products = viewModel!.products
        let selectedProduct = products[products.index(products.startIndex, offsetBy: index)]
        viewModel!.add(product: selectedProduct)
        
    }
    
    func didClickRemove(_ sender:UIButton){
        let index = sender.tag
        let products = viewModel!.products
        let selectedProduct = products[products.index(products.startIndex, offsetBy: index)]
        viewModel!.remove(product: selectedProduct)
    }
    
}


/// Delegate Flow
extension MartViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        print(widthPerItem)
        
        return CGSize(width: widthPerItem, height: 185)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        print(sectionInsets.left)
        return sectionInsets.right
    }
    
}

