//
//  EdgeInteractor.swift
//  PGAnimatorKit
//
//  Created by ipagong on 2018. 8. 9..
//  Copyright © 2018년 pagong. All rights reserved.
//

import UIKit


@objc
open class EdgeInteractor : Interactor {
    
    @objc
    public init(targetView: UIView, edge: PGInteractorEdge) {
        super.init()
        self.edge = edge
        super.targetView = targetView
        super.targetView?.addGestureRecognizer(self.gesutre)
    }
    
    public var edge:PGInteractorEdge = .left {
        didSet { self.gesutre.edges = self.gestureEdge }
    }
    
    private var gestureEdge:UIRectEdge {
        return (self.edge == .right ? .right : .left)
    }
    
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
    
    lazy private var gesutre:UIScreenEdgePanGestureRecognizer = {
        let gesutre = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(onGesture(_:)))
        gesutre.edges = self.gestureEdge
        return gesutre
    }()
    
    // MARK: - action methods
    
    @objc
    func onGesture(_ gesture:UIScreenEdgePanGestureRecognizer) {
        guard let target = willTargetViewController else { return }
        guard let window = willTargetWindow else { return }
        
        let location = gesture.location(in: window)
        let velocity = gesture.velocity(in: window)
        
        var percentage:CGFloat {
            switch edge {
            case .left:  return (location.x / window.bounds.width)
            case .right: return ((window.bounds.width - location.x) / window.bounds.width)
            }
        }
        
        var finished:Bool {
            switch edge {
            case .left:  return (velocity.x > 0)
            case .right: return (velocity.x < 0)
            }
        }
        
        switch gesture.state {
        case .began:   self.began(location)
        case .changed: self.changed(percentage)
        case .ended:   self.ended(finished)
        default:       Interactor.Logger.debug(gesture.state.transitionDebugDescription)
        }
    }
}
