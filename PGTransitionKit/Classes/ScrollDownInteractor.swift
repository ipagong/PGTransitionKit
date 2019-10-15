//
//  ScrollDownInteractor.swift
//  PGAnimatorKit
//
//  Created by ipagong on 2018. 8. 9..
//  Copyright © 2018년 pagong. All rights reserved.
//

import UIKit

@objc(PGScrollDownInteractor)
open class ScrollDownInteractor : Interactor {
    @objc
    public init(targetView: UIScrollView) {
        super.init()
        super.targetView = targetView
        targetView.alwaysBounceVertical = false
        super.targetView?.addGestureRecognizer(self.gesutre)
    }
    
    @objc
    public var distance:CGFloat = 0.0
    
    private var maxDistance:CGFloat {
        if self.distance > 0 { return self.distance }
        
        return (self.targetScrollView?.bounds.height ?? 200) / 2
    }
    
    @objc
    override weak var targetView:UIView? {
        didSet {
            targetView?.addGestureRecognizer(self.gesutre)
        }
        
        willSet {
            guard let view = targetView, view != newValue else { return }
            guard view.gestureRecognizers?.contains(gesutre) == true else { return }
            view.removeGestureRecognizer(gesutre)
        }
    }
    
    lazy private var gesutre:UIPanGestureRecognizer = {
        let gesutre = UIPanGestureRecognizer(target: self, action: #selector(onGesture(_:)))
        gesutre.delegate = self
        return gesutre
    }()
    
    @objc
    func onGesture(_ gesture:UIPanGestureRecognizer) {
        guard let target = willTargetViewController else { return }
        guard let window = willTargetWindow else { return }
        guard let scrollView = self.targetScrollView else { return }
        
        let location = gesture.location(in: window)
        let velocity = gesture.velocity(in: window)
        
        var percentage:CGFloat {
            return ((location.y - beganPoint.y) / maxDistance)
        }
        
        var finished:Bool {
            return (velocity.y > 0.0)
        }
        
        switch gesture.state {
        case .began:
            Interactor.Logger.debug(gesture.state.transitionDebugDescription)
            
        case .changed:
            guard scrollView.contentOffset.y <= scrollView.topVerticalOffset else {
                if hasInteraction == true { self.ended(false) }
                hasInteraction = false
                return
            }
            
            if hasInteraction == false { self.began(location) }
            
            scrollView.holdTopIfOver()
            
            self.changed(percentage)
            
        case .ended:
            guard hasInteraction == true else { return }
            self.ended(finished)
            
        default:
            Interactor.Logger.debug(gesture.state.transitionDebugDescription)
        }
    }
    
    fileprivate var targetScrollView:UIScrollView? { return self.targetView as? UIScrollView }
}

extension ScrollDownInteractor : UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension UIScrollView {
    
    fileprivate var isBouncedTop: Bool { return contentOffset.y <= topVerticalOffset }
    fileprivate var isBouncedBottom: Bool { return contentOffset.y >= bottomVerticalOffset }
    
    fileprivate var topVerticalOffset: CGFloat { return -contentInset.top }
    fileprivate var bottomVerticalOffset: CGFloat { return contentSize.height + contentInset.bottom - bounds.height }
    
    fileprivate func holdTopIfOver() {
        guard isBouncedTop else { return }
        self.contentOffset.y = topVerticalOffset
    }
    
    fileprivate func holdBottomIfOver() {
        guard isBouncedBottom else { return }
        self.contentOffset.y = bottomVerticalOffset
    }
    
}
