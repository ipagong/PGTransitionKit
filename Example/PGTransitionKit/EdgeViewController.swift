//
//  EdgeViewController.swift
//  PGTransitionKit_Example
//
//  Created by ipagong on 19/09/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import PGTransitionKit

class EdgeViewController: UIViewController {
    
    var animator:Animator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = Animator.init(target: self)
    }
}
