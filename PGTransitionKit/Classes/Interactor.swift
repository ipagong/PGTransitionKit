//
//  Interactor.swift
//  PGAnimatorKit
//
//  Created by ipagong on 2018. 8. 7..
//  Copyright © 2018년 pagong. All rights reserved.
//

import UIKit

@objc(PGInteractor)
open class Interactor : NSObject {
    @objc
    public weak var animator:InteractorInput?
    
    @objc
    public var sourceType:SourceType = .present

    @objc
    public var beganPoint:CGPoint = .zero
    
    @objc
    internal weak var targetView:UIView?
    internal var hasInteraction:Bool {
        get { return self.animator?.hasInteraction ?? false }
        set { self.animator?.hasInteraction = newValue }
    }
    
    public var willTargetViewController:UIViewController? {
        switch self.sourceType {
        case .present: return self.animator?.willPresentController
        case .dismiss: return self.animator?.willDismissController
        }
    }
    
    public var willTargetWindow:UIWindow? {
        switch self.sourceType {
        case .present: return self.animator?.target?.view.window
        case .dismiss: return self.animator?.presenting?.view.window
        }
    }
    
    public func startAction() {
        switch self.sourceType {
        case .present: self.animator?.presentAction()
        case .dismiss: self.animator?.dismissAction()
        }
    }
    
    internal func began(_ location:CGPoint) {
        self.animator?.began()
        self.beganPoint = location
        Interactor.Logger.debug("began: " + location.debugDescription)
    }
    
    internal func changed(_ percentage: CGFloat) {
        self.animator?.changed(percentage)
        if percentage > 0 { startAction() }
        Interactor.Logger.debug("changed: " + percentage.description)
    }
    
    internal func ended(_ finish: Bool) {
        self.animator?.ended(finish)
        self.beganPoint = .zero
        Interactor.Logger.debug("ended: " + finish.description)
    }
}

extension UIGestureRecognizer.State {
    internal var transitionDebugDescription: String {
        switch self {
        case .began:      return "began"
        case .cancelled:  return "cancelled"
        case .changed:    return "changed"
        case .ended:      return "ended"
        case .failed:     return "failed"
        case .possible:   return "possible"
        @unknown default: return "unknwon"
        }
    }
}
