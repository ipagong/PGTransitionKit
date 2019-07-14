//
//  Animator+Animation.swift
//  PGAnimatorKit
//
//  Created by ipagong on 2018. 8. 9..
//  Copyright © 2018년 pagong. All rights reserved.
//

import UIKit

extension Animator {
    
    internal func presentAnimation(from:UIViewController, to:UIViewController, container:UIView, context: UIViewControllerContextTransitioning) {
        self.animationData = [String:Any]()
        
        let origin = self.target as? AnimatorOriginable
        let destination = self.presenting as? AnimatorDestinationable
        
        to.view.frame = from.view.frame
        to.view.setNeedsLayout()
        to.view.layoutIfNeeded()
        
        let orgContext = Context.init(target: from, opposite: to,   container: container)
        let dstContext = Context.init(target: to,   opposite: from, container: container)
        
        from.viewWillDisappear(true)
        
        origin?.disppearWhenPresent(status: .prepare, animator: self, context: orgContext)
        destination?.appearWhenPresent(status: .prepare, animator: self, context: dstContext)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: context), delay: 0, options: [], animations: { [weak self] in
            guard let `self` = self else { return }
            
            origin?.disppearWhenPresent(status: .doing, animator: self, context: orgContext)
            destination?.appearWhenPresent(status: .doing, animator: self, context: dstContext)
            
            }, completion: { [weak self] (_) in
                guard let `self` = self else { return }
                
                let canceled = context.transitionWasCancelled
                if canceled == true {
                    self.current = self.target
                    to.view.removeFromSuperview()
                    context.completeTransition(false)
                } else {
                    self.current = self.presenting
                    context.completeTransition(true)
                    from.viewDidDisappear(true)
                }
                
                origin?.disppearWhenPresent(status: canceled ? .cancel :.done, animator: self, context: orgContext)
                destination?.appearWhenPresent(status: canceled ? .cancel :.done, animator: self, context: dstContext)

                self.animationData.values.compactMap { $0 as? UIView }.forEach { $0.removeFromSuperview() }
                self.animationData = [String:Any]()
                
                self.presentBlock?(!canceled)
                self.didActionStart = false
        })
    }
    
    internal func dismissAnimation(from:UIViewController, to:UIViewController, container:UIView, context: UIViewControllerContextTransitioning) {
        self.animationData = [String:Any]()
        
        let origin = self.target as? AnimatorOriginable
        let destination = self.presenting as? AnimatorDestinationable
        
        let orgContext = Context.init(target: to,   opposite: from, container: container)
        let dstContext = Context.init(target: from, opposite: to,   container: container)
        
        to.viewWillAppear(true)
        
        origin?.appearWhenDismiss(status: .prepare, animator: self, context: orgContext)
        destination?.disppearWhenDismiss(status: .prepare, animator: self, context: dstContext)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: context), delay: 0, options: [], animations: { [weak self] in
            guard let `self` = self else { return }
            
            origin?.appearWhenDismiss(status: .doing, animator: self, context: orgContext)
            destination?.disppearWhenDismiss(status: .doing, animator: self, context: dstContext)
            
            }, completion: { [weak self] (_) in
                guard let `self` = self else { return }
                
                let canceled = context.transitionWasCancelled
                
                // do finished views
                
                if canceled == true {
                    self.current = self.presenting
                    to.view.removeFromSuperview()
                    context.completeTransition(false)
                } else {
                    self.current = self.target
                    context.completeTransition(true)
                    to.viewDidAppear(true)
                }
                
                origin?.appearWhenDismiss(status: canceled ? .cancel :.done, animator: self, context: orgContext)
                destination?.disppearWhenDismiss(status: canceled ? .cancel :.done, animator: self, context: dstContext)
                
                self.animationData.values.compactMap { $0 as? UIView }.forEach { $0.removeFromSuperview() }
                self.animationData = [String:Any]()
                
                self.dismissBlock?(!canceled)
                self.didActionStart = false
        })
    }
}
