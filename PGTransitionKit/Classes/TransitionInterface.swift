//
//  Interface.swift
//  PGAnimatorKit
//
//  Created by ipagong on 2018. 8. 7..
//  Copyright © 2018년 pagong. All rights reserved.
//

import UIKit

public typealias AnimatorCompleted = (Bool) -> ()
public typealias AnimatorChecked   = (Animator) -> (Bool)

@objc
public enum PGInteractorEdge : Int {
    case left
    case right
}

@objc
public enum PGInteractorDirection : Int {
    case up
    case left
    case right
    case down
}

@objc
public enum PGInteractorSourceType : Int {
    case present
    case dismiss
}

@objc
public protocol PGAnimatorInteractorInput : NSObjectProtocol {
    var target:UIViewController?     { get }
    var presenting:UIViewController? { get }
    
    var willPresentController:UIViewController? { get }
    var willDismissController:UIViewController? { get }
    
    var hasInteraction:Bool { get set }
    
    func presentAction()
    func dismissAction()
    
    func began()
    func changed(_ percentage: CGFloat)
    func ended(_ finish: Bool)
}

@objc
public enum PGAnimatorStatus : Int {
    case prepare
    case doing
    case done
    case cancel
}

@objc
class PGAnimationContext : NSObject {
    var target:UIViewController
    var opposite:UIViewController
    var container:UIView
    
    init(target: UIViewController, opposite:UIViewController, container:UIView) {
        self.target = target
        self.opposite = opposite
        self.container = container
    }
}

@objc
protocol PGAnimatorOriginable : NSObjectProtocol {    
    func appearWhenDismiss(status: PGAnimatorStatus, animator:Animator, context: PGAnimationContext)
    func disppearWhenPresent(status: PGAnimatorStatus, animator:Animator, context: PGAnimationContext)
}

@objc
protocol PGAnimatorDestinationable : NSObjectProtocol {
    func appearWhenPresent(status: PGAnimatorStatus, animator:Animator, context: PGAnimationContext)
    func disppearWhenDismiss(status: PGAnimatorStatus, animator:Animator, context: PGAnimationContext)
}

extension Interactor {
    public static var debug:Bool = true
    
    public struct Logger {
        public static func debug(_ message: String?) {
            guard Interactor.debug == true else { return }
            debugPrint("[PGInteractor] \(message ?? "nil")")
        }
    }
}

extension Animator {
    public static var debug:Bool = true
    
    public struct Logger {
        public static func debug(_ message: String?) {
            guard Animator.debug == true else { return }
            debugPrint("[PGAnimator] \(message ?? "nil")")
        }
    }
}
