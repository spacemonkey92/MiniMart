# MiniMart
A simple iOS shopping app with a selected list of items.

## Key technologies
1. Swift 3
2. SQLite (Sqlite.swift)
3. RxSwift (Reactive)


## Use cases
1. View Products 
2. Add Products to Cart 
3. Remove Products from cart
4. View Cart 
5. Modify Cart
6. Checkout

## UI
The app has a total of 2 Major screen (Sketch File Attached)
1. View Products List
2. View Cart (Integrated Checkout)


## Product Architecture : MVVM 
This project is build on MVVM architecture leveraging on RxSwift’s reactive programming. The “View” and “ViewModel” binding is done with RxSwift and persisting the "Model" data into SQLite is done with SQLite.Swift framework 

The major Components of the Project are 

### ```MartViewController.swift```:
Displays the list of products and User interactions to add and remove products

### ```MartViewModel.swift```: 
The View Model data required for viewing and interaction of MartViewController.swift

### ```CartViewController.swift```: 
Displays the list of products in the cart and user interactions to modify and checkout the cart

### ```CartViewModel.swift```: 
The View Model required for viewing and interaction of CartViewController.swift

### ```ProductViewModel.swift```: 
Common Sub ViewModel of CartViewModel and MartViewModel for viewing and interaction of products 

## Branches
**master** -> Most shippable product   
**dev** -> Work In Progress

## Build
**Requirement** : Xcode 8 + and Swift 3  

