//
//  Animator+InteractorInput.swift
//  PGAnimatorKit
//
//  Created by ipagong on 2018. 8. 9..
//  Copyright © 2018년 pagong. All rights reserved.
//

import UIKit

extension Animator : InteractorInput {
    @objc
    public var willPresentController:UIViewController? {
        guard let vc = self.presenting else { return nil }
        guard canPresent    == true    else { return nil }
        guard enablePresent == true    else { return nil }
        guard isPresented   == false   else { return nil }
        
        return vc
    }
    
    @objc
    public var willDismissController:UIViewController? {
        guard let vc = self.presenting else { return nil }
        guard canDismiss    == true    else { return nil }
        guard enableDismiss == true    else { return nil }
        guard isPresented   == true    else { return nil }
        
        return vc
    }
    
    @objc
    public func presentAction() {
        guard let vc = self.presenting else { return }
        guard canPresent      == true  else { return }
        guard enablePresent   == true  else { return }
        guard isPresented     == false else { return }
        guard percentComplete == 0     else { return }
        guard didActionStart  == false else { return }
        
        self.didActionStart = true
        self.target?.transitioningDelegate = self
        self.target?.present(vc, animated: true) { [weak self] in self?.didActionStart = false }
    }
    
    @objc
    public func dismissAction() {
        guard let vc = self.presenting else { return }
        guard canDismiss      == true  else { return }
        guard enableDismiss   == true  else { return }
        guard isPresented     == true  else { return }
        guard percentComplete == 0     else { return }
        guard didActionStart  == false else { return }
        
        self.didActionStart = true
        vc.dismiss(animated: true) { [weak self] in self?.didActionStart = false }
    }
    
    @objc
    public func began() {
        self.hasInteraction = true
    }
    
    @objc
    public func changed(_ percentage: CGFloat) {
        self.hasInteraction = true
        self.update(percentage)
    }
    
    @objc
    public func ended(_ finish: Bool) {
        guard self.hasInteraction == true else { return }
        if finish == true {
            self.finish()
        } else {
            self.cancel()
        }
        self.hasInteraction = false
    }
}
