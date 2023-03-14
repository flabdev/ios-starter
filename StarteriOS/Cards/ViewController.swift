//
//  ViewController.swift
//  StarteriOS
//
//  Created by Nagesh Kumar Mishra on 20/02/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CardsViewModel().fetchData()
    }
}

