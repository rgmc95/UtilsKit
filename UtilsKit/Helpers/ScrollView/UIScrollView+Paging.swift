//
//  UIScrollView+Paging.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 22/04/2021.
//  Copyright © 2021 iD.apps. All rights reserved.
//

import UIKit

public enum ScrollDirection: Int {
	case vertical
	case horizontal
}

extension UIScrollView {
	
	public func getCurrentPage(_ orientation: ScrollDirection) -> Int {
		switch orientation {
		case .vertical:
			return Int(self.contentOffset.y / self.frame.height)
			
		case .horizontal:
			return Int(self.contentOffset.x / self.frame.width)
		}
	}
	
	@discardableResult
	public func scrollToPage(_ page: Int, forOrientation orientation: ScrollDirection) -> Bool {
		switch orientation {
		case .vertical:
			let yValue = self.frame.height * page
			if yValue > self.contentSize.height - self.frame.height { return false }
			self.scrollRectToVisible(.init(x: self.contentOffset.x,
										   y: yValue,
										   width: self.frame.width,
										   height: self.frame.height),
									 animated: true)
			
		case .horizontal:
			let xValue = self.frame.width * page
			if xValue > self.contentSize.width - self.frame.width { return false }
			self.scrollRectToVisible(.init(x: xValue,
										   y: self.contentOffset.y,
										   width: self.frame.width,
										   height: self.frame.height),
									 animated: true)
		}
		
		return true
	}
	
	@discardableResult
	public func scrollToNextPage(_ orientation: ScrollDirection) -> Bool {
		self.scrollToPage(self.getCurrentPage(orientation) + 1, forOrientation: orientation)
	}
	
	@discardableResult
	public func scrollToPreviousPage(_ orientation: ScrollDirection) -> Bool {
		self.scrollToPage(self.getCurrentPage(orientation) - 1, forOrientation: orientation)
	}
}
