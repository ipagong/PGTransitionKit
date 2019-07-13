//
//  Animator.swift
//  PGAnimatorKit
//
//  Created by ipagong on 2018. 8. 7..
//  Copyright © 2018년 pagong. All rights reserved.
//

import UIKit

@objc
public class Animator: UIPercentDrivenInteractiveTransition {
    public var tag:String = ""
    
    public var presentBlock:AnimatorCompleted?
    public var dismissBlock:AnimatorCompleted?
    
    public var canPresentBlock:AnimatorChecked?
    public var canDismissBlock:AnimatorChecked?
    
    public var canPresent:Bool { return self.canPresentBlock?(self) ?? true }
    public var canDismiss:Bool { return self.canDismissBlock?(self) ?? true }
    
    public var enablePresent:Bool = true
    public var enableDismiss:Bool = true
    
    public var presentDuration:TimeInterval = 0.3
    public var dismissDuration:TimeInterval = 0.3
    
    public var defaultContainerSetup:Bool = true
    
    public var animationData = [String:Any]()
    
    public var presentInteractor:Interactor? {
        didSet {
            presentInteractor?.animator = self
            presentInteractor?.sourceType = .present
        }
    }
    
    public var dismissInteractor:Interactor? {
        didSet {
            dismissInteractor?.animator = self
            dismissInteractor?.sourceType = .dismiss
        }
    }
    
    public weak var target:UIViewController? {
        didSet  {
            self.target?.transitionAnimator = self
            self.target?.transitioningDelegate = self
        }
        willSet {
            self.target?.transitionAnimator = nil
            self.target?.transitioningDelegate = nil
        }
    }
    
    public weak var presenting:UIViewController? {
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
