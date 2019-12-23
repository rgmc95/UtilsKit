//
//  UIViewController+TraitCollectionType.swift
//  UtilsKit
//
//  Created by RGMC on 26/11/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     Trait collection type (horizontalVertical)
     */
    public var traitCollectionType: TraitCollection {
        switch (self.traitCollection.horizontalSizeClass, self.traitCollection.verticalSizeClass) {
        case (.regular, .regular): return .regularRegular
        case (.regular, .compact): return .regularCompact
        case (.compact, .regular): return .compactRegular
        case (.compact, .compact): return .compactCompact
        default: return .unspecified
        }
    }
}

public enum TraitCollection {
    case regularRegular
    case regularCompact
    case compactRegular
    case compactCompact
    case unspecified
}


