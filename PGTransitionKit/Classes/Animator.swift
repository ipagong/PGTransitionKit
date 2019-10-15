//
//  Animator.swift
//  PGAnimatorKit
//
//  Created by ipagong on 2018. 8. 7..
//  Copyright © 2018년 pagong. All rights reserved.
//

import UIKit

@objc(PGAnimator)
public class Animator: UIPercentDrivenInteractiveTransition {
    @objc public var tag:String = ""
    
    @objc public var presentBlock:AnimatorCompleted?
    @objc public var dismissBlock:AnimatorCompleted?
    
    @objc public var canPresentBlock:AnimatorChecked?
    @objc public var canDismissBlock:AnimatorChecked?
    
    @objc public var canPresent:Bool { return self.canPresentBlock?(self) ?? true }
    @objc public var canDismiss:Bool { return self.canDismissBlock?(self) ?? true }
    
    @objc public var enablePresent:Bool = true
    @objc public var enableDismiss:Bool = true
    
    @objc public var presentDuration:TimeInterval = 0.3
    @objc public var dismissDuration:TimeInterval = 0.3
    
    @objc public var defaultContainerSetup:Bool = true
    
    @objc public var animationData = [String:Any]()
    
    @objc public var presentInteractor:Interactor? {
        didSet {
            presentInteractor?.animator = self
            presentInteractor?.sourceType = .present
        }
        
        willSet {
            presentInteractor?.animator = nil
        }
    }
    
    @objc public var dismissInteractor:Interactor? {
        didSet {
            dismissInteractor?.animator = self
            dismissInteractor?.sourceType = .dismiss
        }
        
        willSet {
            dismissInteractor?.animator = nil
        }
    }
    
    @objc public weak var target:UIViewController? {
        didSet  {
            self.target?.transitionAnimator = self
            self.target?.transitioningDelegate = self
        }
        willSet {
            self.target?.transitionAnimator = nil
            self.target?.transitioningDelegate = nil
        }
    }
    
    @objc public weak var presenting:UIViewController? {
        didSet  {
            self.presenting?.transitionAnimator = self
            self.presenting?.transitioningDelegate = self
        }
        willSet {
            self.presenting?.transitionAnimator = nil
            self.presenting?.transitioningDelegate = nil
        }
    }
    
    weak var current:UIViewController?
    
    internal var isPresented:Bool { return current != target }
    
    @objc
    public var hasInteraction:Bool = false
    
    var didActionStart:Bool = false
    
    @objc
    override init() { super.init() }
    
    @objc
    public init(target:UIViewController) {
        super.init()
        
        self.target  = target
        self.current = target
        
        self.target?.transitionAnimator = self
        self.target?.transitioningDelegate = self
    }
    
    @objc
    public init(target:UIViewController, presenting:UIViewController) {
        super.init()
        
        self.current = target
        
        self.target = target
        self.presenting = presenting
        
        self.target?.transitionAnimator        = self
        self.target?.transitioningDelegate     = self
        self.presenting?.transitionAnimator    = self
        self.presenting?.transitioningDelegate = self
    }
    
    deinit {
        self.target     = nil
        self.presenting = nil
    }
}

extension Animator {
    
    @objc public func setPresentCompletion(block:AnimatorCompleted?) { self.presentBlock = block }
    @objc public func setDismissCompletion(block:AnimatorCompleted?) { self.dismissBlock = block }
    
    @objc public func setCanPresentBlock(block:AnimatorChecked?) { self.canPresentBlock = block }
    @objc public func setCanDismissBlock(block:AnimatorChecked?) { self.canDismissBlock = block }

}
