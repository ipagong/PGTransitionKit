//
//  ScrollDownInteractor.swift
//  PGAnimatorKit
//
//  Created by ipagong on 2018. 8. 9..
//  Copyright © 2018년 pagong. All rights reserved.
//

import UIKit

@objc
open class ScrollDownInteractor : Interactor {
    
    @objc
    public init(targetView: UIScrollView) {
        super.init()
        super.targetView = targetView
    }
    
    override weak var targetView:UIView? {
        didSet {
            guard let scrollBase = targetView as? UIScrollView else { return }
            scrollBase.delegate = self
            scrollBase.bounces = true
            scrollBase.alwaysBounceVertical = true
        }
        
        willSet {
            guard let view = targetView, view != newValue else { return }
            guard let scrollBase = targetView as? UIScrollView else { return }
            scrollBase.delegate = nil
        }
    }
    
    fileprivate var targetScrollView:UIScrollView? { return self.targetView as? UIScrollView }

    public weak var scrollViewDelegate:UIScrollViewDelegate?
}

extension ScrollDownInteractor : UIScrollViewDelegate {
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.scrollViewDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        
        guard scrollView.contentOffset.y <= scrollView.topVerticalOffset else { return }
        
        targetContentOffset.pointee = scrollView.contentOffset
        
        guard hasInteraction == true else { return }
        
        let finished = velocity.y < 0.0
        
        self.ended(finished)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.holdBottomIfOver()
        self.scrollViewDelegate?.scrollViewDidScroll?(scrollView)
        
        guard let scrollBase = self.targetScrollView else { return }
        guard scrollBase == scrollView else { return }
        
        guard scrollView.contentOffset.y < scrollView.topVerticalOffset else {
            if hasInteraction == true { self.ended(false) }
            hasInteraction = false
            return
        }
        
        guard scrollView.isDragging == true else { return }
        guard scrollView.isDecelerating == false else { return }
        
        let percentage = ((-1 * scrollView.contentOffset.y) / (scrollView.bounds.height/2))
        
        self.changed(percentage)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewDidZoom?(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.scrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.scrollViewDelegate?.viewForZooming?(in: scrollView)
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.scrollViewDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.scrollViewDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return self.scrollViewDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewDidScrollToTop?(scrollView)
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
