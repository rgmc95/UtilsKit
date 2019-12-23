//
//  PagerView.swift
//  UtilsKit
//
//  Created by RGMC on 24/09/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import UIKit

public protocol PagerViewDelegate: class, UIScrollViewDelegate {
    func pageDidChange(_ page: Int)
}

open class PagerView: UIView, UIScrollViewDelegate {
    
    //MARK: - Scroll direction
    public enum PagerViewScrollDirection {
        case vertical, horizontal
    }
    
    //MARK: - Variables
    private var oldOrientation: UIDeviceOrientation!
    private var scrollView: UIScrollView!
    private var innerViews: [UIView] = []
    
    /**
     The current page of the pager.
     */
    public private(set) var page = 0
    
    /**
     The scroll direction of the pager.
     */
    public private(set) var scrollDirection: PagerViewScrollDirection = .horizontal
    
    /**
     Pager delegate
     */
    public weak var delegate: PagerViewDelegate?
    
    //MARK: - Scroll view variables
    public var isPagingEnabled: Bool {
        get { return scrollView.isPagingEnabled }
        set { scrollView.isPagingEnabled = newValue }
    }
    
    public var isScrollEnabled: Bool {
        get { return scrollView.isScrollEnabled }
        set { scrollView.isScrollEnabled = newValue }
    }
    
    public var bounces: Bool {
        get { return scrollView.bounces }
        set { scrollView.bounces = newValue }
    }
    
    public var showsVerticalScrollIndicator: Bool {
        get { return scrollView.showsVerticalScrollIndicator }
        set { scrollView.showsVerticalScrollIndicator = newValue }
    }
    
    public var showsHorizontalScrollIndicator: Bool {
        get { return scrollView.showsHorizontalScrollIndicator }
        set { scrollView.showsHorizontalScrollIndicator = newValue }
    }
    
    //MARK: - Scroll View overrides
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self._scrollToPage(self.page)
    }
    
    //MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    public init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func setupUI() {
        self.oldOrientation = UIDevice.current.orientation
        NotificationCenter.default.addObserver(self, selector: #selector(didRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func initScrollView() {
        // Scroll view
        self.subviews.forEach{$0.removeFromSuperview()}
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.backgroundColor = .clear
        self.scrollView.isPagingEnabled = true
        self.addSubview(self.scrollView)
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.scrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.rightAnchor)
            ])
        
        initInnerViews()
    }
    
    private func initInnerViews() {
        // Inner views
        var previousView: UIView = self.scrollView
        var constraints: [NSLayoutConstraint] = []
        
        for (index, view) in innerViews.enumerated() {
            
            view.translatesAutoresizingMaskIntoConstraints = false
            view.localize()
            self.scrollView.addSubview(view)
            
            constraints.append(contentsOf: [
                view.heightAnchor.constraint(equalTo: self.heightAnchor),
                view.widthAnchor.constraint(equalTo: self.widthAnchor)
            ])
            
            switch scrollDirection {
            case .horizontal:
                constraints.append(contentsOf: [
                    view.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
                    view.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
                    ])
                if index == 0 {
                    constraints.append(view.leftAnchor.constraint(equalTo: previousView.leftAnchor))
                } else {
                    constraints.append(view.leftAnchor.constraint(equalTo: previousView.rightAnchor))
                }
                if index == innerViews.count - 1 {
                    constraints.append(view.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor))
                }
                
            case .vertical:
                constraints.append(contentsOf: [
                    view.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
                    view.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor)
                ])
                if index == 0 {
                    constraints.append(view.topAnchor.constraint(equalTo: previousView.topAnchor))
                } else {
                    constraints.append(view.topAnchor.constraint(equalTo: previousView.bottomAnchor))
                }
                if index == innerViews.count - 1 {
                    constraints.append(view.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor))
                }
            }
            
            NSLayoutConstraint.activate(constraints)
            previousView = view
        }
    }
    
    //MARK: - Scroll view delegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidZoom?(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.delegate?.scrollViewWillEndDragging?(scrollView
            , withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let oldPage = self.page
        
        switch scrollDirection {
        case .horizontal:
            self.page = Int(self.scrollView.contentOffset.x / self.scrollView.frame.size.width)
        case .vertical:
            self.page = Int(self.scrollView.contentOffset.y / self.scrollView.frame.size.height)
        }
        
        if oldPage != self.page {
            self.delegate?.pageDidChange(page)
        }
        self.delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.delegate?.viewForZooming?(in: scrollView)
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.delegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.delegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return self.delegate?.scrollViewShouldScrollToTop?(scrollView) ?? false
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
    @available(iOS 11.0, *)
    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    }
    
    //MARK: - Actions
    @objc private func didRotate() {
        let orientation = UIDevice.current.orientation
        
        defer {
            if !orientation.isFlat {
                self.oldOrientation = orientation
            }
        }
        
        if !orientation.isFlat && oldOrientation != orientation {
            self._scrollToPage(self.page)
        }
    }
    
    //MARK: - Utils
    
    /**
     
     Configure the pager.
     
     - parameter views: the views contained in pager.
     - parameter scrollDirection: the direction of the scroll. Default is set to `horizontal`
     
     */
    public func configure(withViews views: [UIView], delegate: PagerViewDelegate? = nil, scrollDirection: PagerViewScrollDirection = .horizontal) {
        self.innerViews = views
        if delegate != nil {
            self.delegate = delegate
        }
        self.scrollDirection = scrollDirection
        self.initScrollView()
    }
    
    private func _scrollToPage(_ page: Int, animationDuration: TimeInterval = 0) {
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self = self else { return }
            switch self.scrollDirection {
            case .horizontal:
                let contentOffsetX = CGFloat(page) * self.scrollView.frame.size.width
                self.scrollView.contentOffset.x = contentOffsetX
            case .vertical:
                let contentOffsetY = CGFloat(page) * self.scrollView.frame.size.height
                self.scrollView.contentOffset.y = contentOffsetY
            }
        }
    }
    
    /**
     
     Scroll to the given page.
     The scroll is performed only if `isPagingEnabled` is set to `true`.
     
     - parameter page: the page to scroll to.
     - parameter animationDuration: the duration of the animation. `0` is default and not animated.
     
     */
    public func scrollToPage(_ page: Int, animationDuration: TimeInterval = 0) {
        if scrollView.isPagingEnabled {
            _scrollToPage(page, animationDuration: animationDuration)
            scrollViewDidEndDecelerating(self.scrollView)
        }
    }
}
