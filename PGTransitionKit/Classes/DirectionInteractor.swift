//
//  DirectionInteractor.swift
//  PGAnimatorKit
//
//  Created by ipagong on 2018. 8. 9..
//  Copyright © 2018년 pagong. All rights reserved.
//

import UIKit

@objc(PGDirectionInteractor)
open class DirectionInteractor : Interactor {
    
    @objc
    public init(targetView: UIView, direction: Direction) {
        super.init()
        self.direction = direction
        super.targetView = targetView
        super.targetView?.addGestureRecognizer(self.gesutre)
    }
    
    @objc
    public init(targetView: UIView, direction: Direction, distance:CGFloat) {
        super.init()
        self.direction = direction
        self.distance = distance
        super.targetView = targetView
        super.targetView?.addGestureRecognizer(self.gesutre)
    }
    
    @objc
    public var direction:Direction = .left
    
    @objc
    public var distance:CGFloat = 0.0

    private var maxDistance:CGFloat {
        if self.distance > 0 { return self.distance }
        
        switch direction {
        case .up,    .down: return targetView?.bounds.height ?? 0
        case .left, .right: return targetView?.bounds.width  ?? 0
        }
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
    
    // MARK: - action methods
    
    @objc
    func onGesture(_ gesture:UIPanGestureRecognizer) {
        guard let target = willTargetViewController else { return }
        guard let window = willTargetWindow else { return }
        
        let location = gesture.location(in: window)
        let velocity = gesture.velocity(in: window)
        
        var percentage:CGFloat {
            switch direction {
            case .left:  return ((beganPoint.x - location.x) / maxDistance)
            case .up:    return ((beganPoint.y - location.y) / maxDistance)
            case .right: return ((location.x - beganPoint.x) / maxDistance)
            case .down:  return ((location.y - beganPoint.y) / maxDistance)
            }
        }

        var finished:Bool {
            switch direction {
            case .left:  return (velocity.x > 0)
            case .up:    return (velocity.y < 0)
            case .right: return (velocity.x < 0)
            case .down:  return (velocity.y > 0)
            }
        }
        
        switch gesture.state {
        case .began:   self.began(location)
        case .changed: self.changed(percentage)
        case .ended:   self.ended(finished)
        default: Interactor.Logger.debug(gesture.state.transitionDebugDescription)
        }
    }
}

extension DirectionInteractor : UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
