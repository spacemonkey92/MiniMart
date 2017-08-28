//
//  ViewController.swift
//  MiniMart
//
//  Created by nitin muthyala on 27/8/17.
//  Copyright © 2017 Spaceage Labs. All rights reserved.
//

import UIKit

class MartViewController: UIViewController  {

    @IBOutlet weak var productsCollectionView: UICollectionView!
    var viewModel : MartViewModle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension MartViewController:  UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}

