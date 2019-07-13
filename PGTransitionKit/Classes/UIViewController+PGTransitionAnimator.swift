//
//  UIViewController+.swift
//  PGAnimatorKit
//
//  Created by ipagong on 2018. 8. 9..
//  Copyright © 2018년 pagong. All rights reserved.
//

import UIKit
import ObjectiveC

private var transitionAniamtorAssociatedKey: UInt8 = 0

internal class AnimatorWeak : NSObject {
    weak var weakObject : Animator?
    
    init(_ weakObject: Animator?) {
        self.weakObject = weakObject
    }
}

extension UIViewController {

    @objc
    public var transitionAnimator:Animator? {
        get {
            let weakWrapper: AnimatorWeak? = objc_getAssociatedObject(self, &transitionAniamtorAssociatedKey) as? AnimatorWeak
            return weakWrapper?.weakObject
        }
        set {
            var weakWrapper: AnimatorWeak? = objc_getAssociatedObject(self, &transitionAniamtorAssociatedKey) as? AnimatorWeak
            if weakWrapper == nil {
                weakWrapper = AnimatorWeak(newValue)
                objc_setAssociatedObject(self, &transitionAniamtorAssociatedKey, weakWrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            } else {
                weakWrapper!.weakObject = newValue
            }
        }
    }
}
