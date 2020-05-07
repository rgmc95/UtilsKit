//
//  CollectionViewCell.swift
//  UtilsKit
//
//  Created by RGMC on 28/03/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Cell
/**
    Default empty collection view cell
 */
public final class UIEmptyCollectionViewCell: UICollectionViewCell, ViewReusable {
    public static var nibName: String? = ""
    public static var identifier: String = "UIEmptyCollectionViewCell"
}

extension ViewReusable where Self: UICollectionViewCell & ViewReusable {
    
    // MARK: Register
    private static func registerCell(withCollectionView collectionView: UICollectionView,
                                     withIdentifier identifier: String? = nil) {
        
        guard let nibName = self.nibName else { return }
        if nibName.isEmpty {
            collectionView.register(Self.self, forCellWithReuseIdentifier: self.identifier)
        } else {
            collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: identifier ?? self.identifier)
        }
    }
    
    // MARK: Dequeue
    internal static func dequeueCell(withCollectionView collectionView: UICollectionView,
                                     forIndexPath indexPath: IndexPath,
                                     withIdentifier identifier: String? = nil) -> Self? {
        
        self.registerCell(withCollectionView: collectionView, withIdentifier: identifier)
        return dequeueCellAux(withCollectionView: collectionView, forIndexPath: indexPath, withIdentifier: identifier)
    }
    
    internal static func dequeueCellAux(withCollectionView collectionView: UICollectionView,
                                        forIndexPath indexPath: IndexPath,
                                        withIdentifier identifier: String? = nil) -> Self? {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier ?? self.identifier, for: indexPath) as? Self else {
            return nil
        }
        
        return cell
    }
}

extension UICollectionView {
    
    /**
     
     Dequeue a cell from collection view with given cell type at given index path.
     
     The cell needs to conform to `ViewReusable`.
     
     This methods initializes and registers the cell if needed.
     
     - parameter indexPath: Index path of the cell to dequeue
     
     - returns: Dequeued cell for given type
     
     */
    public func dequeueCell<T: UICollectionViewCell & ViewReusable>(forIndexPath indexPath: IndexPath,
                                                                    withIdentifier identifier: String? = nil) -> T {
        guard let cell = T.dequeueCell(withCollectionView: self, forIndexPath: indexPath, withIdentifier: identifier) else {
            fatalError("Cannot dequeue cell \(String(describing: T.self)) with identifier \(identifier ?? T.identifier)")
        }
        return cell
    }
    
    /**
     
     Dequeue an empty cell from collection view.
     
     - parameter indexPath: Index path of the cell to dequeue
     
     - returns: an empty cell
     
     */
    public func dequeueEmptyCell(forIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UIEmptyCollectionViewCell = self.dequeueCell(forIndexPath: indexPath)
        return cell
    }
}
