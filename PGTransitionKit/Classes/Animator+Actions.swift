//
//  Animator+Actions.swift
//  PGAnimatorKit
//
//  Created by ipagong on 2018. 8. 9..
//  Copyright © 2018년 pagong. All rights reserved.
//

import UIKit

extension Animator {
    @objc
    public func presentAnimatorViewController() {
        self.presentAnimatorViewController(animated: true, completion: nil)
    }
    
    @objc
    public func presentAnimatorViewController(animated:Bool) {
        self.presentAnimatorViewController(animated: animated, completion: nil)
    }
    
    @objc
    public func presentAnimatorViewController(animated:Bool, completion:AnimatorCompleted?) {
        guard let vc = self.presenting else { return }
        guard canPresent      == true  else { return }
        guard enablePresent   == true  else { return }
        guard isPresented     == false else { return }
        guard percentComplete == 0     else { return }
        guard didActionStart  == false else { return }
        
        self.didActionStart = true
        vc.transitioningDelegate  = self
        
        self.target?.present(vc, animated: animated) { completion?(true) }
    }
}

extension Animator {
    @objc
    public func dismissAnimatorViewController() {
        self.dismissAnimatorViewController(animated: true, completion: nil)
    }
    
    @objc
    public func dismissAnimatorViewController(animated:Bool) {
        self.dismissAnimatorViewController(animated: animated, completion: nil)
    }
    
    @objc
    public func dismissAnimatorViewController(animated:Bool, completion:AnimatorCompleted?) {
        guard let vc = self.presenting else { return }
        guard canDismiss      == true  else { return }
        guard enableDismiss   == true  else { return }
        guard isPresented     == true  else { return }
        guard percentComplete == 0     else { return }
        guard didActionStart  == false else { return }
        
        self.didActionStart = true
        vc.transitioningDelegate = self
        
        vc.dismiss(animated: animated) { completion?(true) }
    }
}
