//
//  ViewController.swift
//  Baz Movies
//
//  Created by Jesús Tirado on 05/05/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if navigationController?.viewControllers.first === self {
            let listVC = MovieListRouter.createModule()
            navigationController?.pushViewController(listVC, animated: false)
        }
    }
    
    
}

