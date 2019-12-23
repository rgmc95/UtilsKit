//
//  CollectionViewCell.swift
//  UtilsKit
//
//  Created by RGMC on 28/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation
import UIKit


//MARK: - Cell
/**
    Default empty collection view cell
 */
public final class UIEmptyCollectionViewCell: UICollectionViewCell, ViewReusable {
    public static var nibName: String? = ""
    public static var identifier: String = "UIEmptyCollectionViewCell"
}

extension ViewReusable where Self: UICollectionViewCell {
    
    //MARK: Register
    fileprivate static func registerCell<T: UICollectionViewCell & ViewReusable>(ofType type: T.Type, withCollectionView collectionView: UICollectionView, withIdentifier identifier: String? = nil) {
        guard let nibName = self.nibName else { return }
        if nibName.isEmpty {
            collectionView.register(type, forCellWithReuseIdentifier: self.identifier)
        } else {
            collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: identifier ?? self.identifier)
        }
    }
    
    //MARK: Dequeue
    fileprivate static func dequeueCell<T: UICollectionViewCell & ViewReusable>(ofType type: T.Type, withCollectionView collectionView: UICollectionView, forIndexPath indexPath: IndexPath, withIdentifier identifier: String? = nil) -> Self {
        self.registerCell(ofType: type, withCollectionView: collectionView, withIdentifier: identifier)
        return _dequeueCell(withCollectionView: collectionView, forIndexPath: indexPath, withIdentifier: identifier)!
    }
    
    fileprivate static func _dequeueCell(withCollectionView collectionView: UICollectionView, forIndexPath indexPath: IndexPath, withIdentifier identifier: String? = nil) -> Self? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier ?? self.identifier, for: indexPath) as? Self else {
            return nil
        }
        
        return cell
    }
}

//MARK: - Header/Footer

/**
 
 This protocol lightens collection view reusable view dequeuement.
 It provides methods to register, initialize and dequeue view with a single call.
 
 To make reusable view compliants with this protocol, implement:
 
 - nibName: name of the xib
 - identifier: identifier of the view
 - kind: kind of view. Either `header` or `footer`
 
 */
public protocol CollectionViewHeaderFooterViewReusable: ViewReusable {
    static var kind: CollectionViewReusableViewKind {get}
}

/**
 Wrapper of reusable view kind
 */
public enum CollectionViewReusableViewKind {
    case header, footer
    
    var rawValue: String {
        switch self {
        case .header: return UICollectionView.elementKindSectionHeader
        case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}

extension CollectionViewHeaderFooterViewReusable where Self: UICollectionReusableView {
    
    //MARK: Register
    internal static func registerView<T: CollectionViewHeaderFooterViewReusable & NSObject>(ofType type: T.Type, withCollectionView collectionView: UICollectionView, withIdentifier identifier: String? = nil) {
        guard let nibName = Self.nibName else { return }

        if nibName.isEmpty {
            collectionView.register(type, forSupplementaryViewOfKind: self.kind.rawValue, withReuseIdentifier: identifier ?? self.identifier)
        } else {
            collectionView.register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: self.kind.rawValue, withReuseIdentifier: identifier ?? self.identifier)
        }
    }
    
    //MARK: Dequeue
    internal static func _dequeueView(withCollectionView collectionView: UICollectionView, forIndexPath indexPath: IndexPath, withIdentifier identifier: String? = nil) -> Self? {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: self.kind.rawValue, withReuseIdentifier: identifier ?? self.identifier, for: indexPath) as? Self else {
            return nil
        }
        
        return view
    }
    
    internal static func dequeueView<T: CollectionViewHeaderFooterViewReusable & NSObject>(ofType type: T.Type, withCollectionView collectionView: UICollectionView, forIndexPath indexPath: IndexPath, withIdentifier identifier: String? = nil) -> Self {
        self.registerView(ofType: type, withCollectionView: collectionView, withIdentifier: identifier)
        return _dequeueView(withCollectionView: collectionView, forIndexPath: indexPath, withIdentifier: identifier)!
    }
}

extension UICollectionView {
    
    /**
     
     Dequeue a cell from collection view with given cell type at given index path.
     
     The cell needs to conform to `ViewReusable`.
     
     This methods initializes and registers the cell if needed.
     
     - parameter type: Type of the cell to dequeue
     - parameter indexPath: Index path of the cell to dequeue
     
     - returns: Dequeued cell for given type
     
     */
    public func dequeueCell<T: UICollectionViewCell & ViewReusable>(_ type: T.Type, forIndexPath indexPath: IndexPath, withIdentifier identifier: String? = nil) -> T {
        return T.dequeueCell(ofType: type, withCollectionView: self, forIndexPath: indexPath, withIdentifier: identifier)
    }
    
    /**
     
     Dequeue an empty cell from collection view.
     
     - parameter indexPath: Index path of the cell to dequeue
     
     - returns: an empty cell
     
     */
    public func dequeueEmptyCell(forIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        return self.dequeueCell(UIEmptyCollectionViewCell.self, forIndexPath: indexPath)
    }
    
    /**
     
     Dequeue a header or footer view from collection view with given view type at given index path.
     
     The reusable view needs to conform to `CollectionViewHeaderFooterViewReusable`.
     
     This methods initializes and registers the view if needed.
     
     - parameter type: Type of the view to dequeue
     - parameter indexPath: Index path of the view to dequeue
     
     - returns: Dequeued view for given type
     
     */
    public func dequeueView<T: CollectionViewHeaderFooterViewReusable & UICollectionReusableView>(_ type: T.Type, forIndexPath indexPath: IndexPath, withIdentifier identifier: String? = nil) -> T {
        return T.dequeueView(ofType: type, withCollectionView: self, forIndexPath: indexPath, withIdentifier: identifier)
    }
}

