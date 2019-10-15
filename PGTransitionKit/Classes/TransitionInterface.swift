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

@objc(PGEdge)
public enum Edge : Int {
    case left
    case right
}

@objc(PGDirection)
public enum Direction : Int {
    case up
    case left
    case right
    case down
}

@objc(PGSourceType)
public enum SourceType : Int {
    case present
    case dismiss
}

@objc(PGInteractorInput)
public protocol InteractorInput : NSObjectProtocol {
    @objc var target:UIViewController?     { get }
    @objc var presenting:UIViewController? { get }
    
    @objc var willPresentController:UIViewController? { get }
    @objc var willDismissController:UIViewController? { get }
    
    @objc var hasInteraction:Bool { get set }
    
    @objc func presentAction()
    @objc func dismissAction()
    
    @objc func began()
    @objc func changed(_ percentage: CGFloat)
    @objc func ended(_ finish: Bool)
}

@objc(PGStatus)
public enum Status : Int {
    case prepare
    case doing
    case done
    case cancel
}

@objc(PGContext)
public class Context : NSObject {
    @objc public var target:UIViewController
    @objc public var opposite:UIViewController
    @objc public var container:UIView
    
    @objc
    init(target: UIViewController, opposite:UIViewController, container:UIView) {
        self.target = target
        self.opposite = opposite
        self.container = container
    }
}

@objc(PGAnimatorOriginable)
public protocol AnimatorOriginable : NSObjectProtocol {
    @objc func appearWhenDismiss(status: Status, animator:Animator, context: Context)
    @objc func disppearWhenPresent(status: Status, animator:Animator, context: Context)
}

@objc(PGAnimatorDestinationable)
public protocol AnimatorDestinationable : NSObjectProtocol {
    @objc func appearWhenPresent(status: Status, animator:Animator, context: Context)
    @objc func disppearWhenDismiss(status: Status, animator:Animator, context: Context)
}

extension Interactor {
    @objc public static var debug:Bool = true
    
    public struct Logger {
        public static func debug(_ message: String?) {
            guard Interactor.debug == true else { return }
            debugPrint("[PGInteractor] \(message ?? "nil")")
        }
    }
}

extension Animator {
    @objc public static var debug:Bool = true
    
    public struct Logger {
        public static func debug(_ message: String?) {
            guard Animator.debug == true else { return }
            debugPrint("[PGAnimator] \(message ?? "nil")")
        }
    }
}
