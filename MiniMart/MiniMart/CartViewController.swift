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
import Adyen

class CartViewController: UIViewController {
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var checkOutBtn: UIButton!
    @IBOutlet weak var totalBtn: UIButton!
    @IBOutlet weak var currencyBtn: UIBarButtonItem!

    
    // ViewModel
    var viewModel : CartViewModel? {
        didSet {
            bindData()
        }
    }
    let disposeBag = DisposeBag()
    var currency : CURRENCY = CURRENCY.SGD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup(){
        self.viewModel = CartViewModel(currency: currency)
        // Do any additional setup after loading the view.
        setupTableView()
        
        switch self.currency {
        case .SGD:
            self.currencyBtn.title = "SGD"
            break
        case .USD:
            self.currencyBtn.title = "USD"
            break
        }
    }
    
    
    // MARK:- Rx Swift binding
    func bindData(){
        viewModel?.cartTotal.asObservable()
            .subscribe(onNext: { count in
                self.totalBtn.setTitle(self.viewModel?.totalCostPretty(), for: .normal)
            })
            .addDisposableTo(disposeBag)
    }
    
    // MARK:- View Setups
    func setupTableView(){
        // Register cell
        let nibName = UINib(nibName: "CartItemCell", bundle:nil)
        self.cartTableView.register(nibName, forCellReuseIdentifier: "CartCell")
        
        // Rx Bind the list with table view
        
        viewModel?.cartProducts.asObservable()
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
    
    
    // MARL:- Currency
    func didClickSwitchCrcy(){
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        
        let sgd: UIAlertAction = UIAlertAction(title: "SGD", style: .default){ action -> Void in
            self.cartTableView.delegate = nil
            self.cartTableView.dataSource = nil
            self.currency = .SGD
            self.initialSetup()
        }
        let usd: UIAlertAction = UIAlertAction(title: "USD", style: .default){ action -> Void in
            self.currency = .USD
            self.cartTableView.delegate = nil
            self.cartTableView.dataSource = nil
            self.initialSetup()
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
    
    func didClickRemove(_ sender:UIButton){
        let index = sender.tag
        let products = viewModel!.cartProducts.value
        let selectedProduct = products[products.index(products.startIndex, offsetBy: index)]
        viewModel!.remove(product: selectedProduct)
    }
    
    @IBAction func didClickCheckOut(_ sender: Any) {
        let viewController = CheckoutViewController(delegate: self)
        present(viewController, animated: true, completion: nil)
    }
    @IBAction func didClickTotoal(_ sender: Any) {
        
    }
    @IBAction func didClickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didClickCurrency(_ sender: Any) {
        didClickSwitchCrcy()
    }
    

}

extension CartViewController : CheckoutViewControllerDelegate{
    
    
    func checkoutViewController(_ controller: CheckoutViewController, requiresPaymentDataForToken token: String, completion: @escaping DataCompletion) {
        
        let paymentDetails: [String: Any] = [
            "amount": [
                "value": 17408,
                "currency": "SGD"
            ],
            "countryCode": "NL",
            "shopperReference": "user349857934",
            "returnUrl": "minimart://", // Your App URI Scheme.
            "channel": "ios",
            "token": token   // Pass the `token` received from SDK.
        ]
        
        // For your convenience, we offer a test merchant server. Always use your own implementation when testing before going live.
        let url = URL(string: "https://checkoutshopper-test.adyen.com/checkoutshopper/demoserver/setup")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: paymentDetails, options: [])
        
        request.allHTTPHeaderFields = [
            "X-Demo-Server-API-Key": "Checkout_DEMO_API_key", // Replace with your own Checkout Demo API key.
            "Content-Type": "application/json"
        ]
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { data, response, error in
            if let data = data {
                completion(data)
            }
            }.resume()
    }
    
    
    func checkoutViewController(_ controller: CheckoutViewController, requiresReturnURL completion: @escaping URLCompletion){
        let openURL = URL(fileURLWithPath: "minimart://")
        completion(openURL)
    }
    
    func checkoutViewController(_ controller: CheckoutViewController, didFinishWith result: PaymentRequestResult){
        
    }
    
}
