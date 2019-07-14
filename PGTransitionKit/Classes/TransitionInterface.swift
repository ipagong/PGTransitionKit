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
public enum Edge : Int {
    case left
    case right
}

@objc
public enum Direction : Int {
    case up
    case left
    case right
    case down
}

@objc
public enum SourceType : Int {
    case present
    case dismiss
}

@objc
public protocol InteractorInput : NSObjectProtocol {
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
public enum Status : Int {
    case prepare
    case doing
    case done
    case cancel
}

@objc
public class Context : NSObject {
    public var target:UIViewController
    public var opposite:UIViewController
    public var container:UIView
    
    init(target: UIViewController, opposite:UIViewController, container:UIView) {
        self.target = target
        self.opposite = opposite
        self.container = container
    }
}

@objc
public protocol AnimatorOriginable : NSObjectProtocol {
    func appearWhenDismiss(status: Status, animator:Animator, context: Context)
    func disppearWhenPresent(status: Status, animator:Animator, context: Context)
}

@objc
public protocol AnimatorDestinationable : NSObjectProtocol {
    func appearWhenPresent(status: Status, animator:Animator, context: Context)
    func disppearWhenDismiss(status: Status, animator:Animator, context: Context)
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
