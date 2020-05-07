 //
 //  ViewReusable.swift
 //  UtilsKit
 //
 //  Created by RGMC on 28/03/2018.
 //  Copyright © 2018 RGMC. All rights reserved.
 //
 
 import Foundation
 import UIKit
 
 // MARK: - Cell
 extension ViewReusable where Self: UITableViewCell {
    
    // MARK: Register
    internal static func registerCell(withTableview tableview: UITableView,
                                      forCellReuseIdentifier identifier: String? = nil) {
        
        guard let nibName = self.nibName else { return }
        tableview.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: identifier ?? self.identifier)
    }
    
    // MARK: Dequeue cell with indexpath
    private static func dequeueCellAux(withTableView tableView: UITableView,
                                       forIndexPath indexPath: IndexPath,
                                       withIdentifier identifier: String? = nil) -> Self? {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier ?? self.identifier, for: indexPath) as? Self else {
            return nil
        }
        
        return cell
    }
    
    internal static func dequeueCell(withTableView tableView: UITableView,
                                     forIndexPath indexPath: IndexPath,
                                     withIdentifier identifier: String? = nil) -> Self? {
        
        self.registerCell(withTableview: tableView, forCellReuseIdentifier: identifier)
        return dequeueCellAux(withTableView: tableView, forIndexPath: indexPath, withIdentifier: identifier)
    }
    
    // MARK: Dequeue cell without indexpath
    internal static func dequeueCellAux(withTableView tableView: UITableView,
                                        withIdentifier identifier: String? = nil) -> Self? {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier ?? self.identifier) as? Self else {
            return nil
        }
        
        return cell
    }
    
    internal static func dequeueCell(withTableView tableView: UITableView,
                                     withIdentifier identifier: String? = nil) -> Self? {
        
        guard let cell = dequeueCellAux(withTableView: tableView, withIdentifier: identifier) else {
            self.registerCell(withTableview: tableView, forCellReuseIdentifier: identifier)
            return dequeueCellAux(withTableView: tableView, withIdentifier: identifier)
        }
        
        return cell
    }
 }
 
 // MARK: - Header/Footer
 extension ViewReusable where Self: UITableViewHeaderFooterView {
    
    // MARK: Register
    internal static func registerHeaderFooterView(withTableview tableview: UITableView,
                                                  withIdentifier identifier: String? = nil) {
        
        guard let nibName = Self.nibName else { return }
        tableview.register(UINib(nibName: nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier ?? self.identifier)
    }
    
    // MARK: Dequeue header or footer view
    internal static func dequeueHeaderFooterViewAux(withTableView tableView: UITableView,
                                                    withIdentifier identifier: String? = nil) -> Self? {
        
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier ?? self.identifier) as? Self else {
            return nil
        }
        
        return cell
    }
    
    internal static func dequeueHeaderFooterView(withTableView tableView: UITableView,
                                                 withIdentifier identifier: String? = nil) -> Self? {
        
        guard let cell = dequeueHeaderFooterViewAux(withTableView: tableView, withIdentifier: identifier) else {
            self.registerHeaderFooterView(withTableview: tableView, withIdentifier: identifier)
            return dequeueHeaderFooterViewAux(withTableView: tableView, withIdentifier: identifier)
        }
        
        return cell
    }
 }
 
 extension UITableView {
    
    /**
     
     Dequeue a cell from table view with given cell type.
     
     The cell needs to conform to `TableViewElementReusable` and be of type `UITableViewCell`.
     
     This methods initializes and registers the cell if needed and performs.
     
     - parameter type: Type of the cell to dequeue
     
     - returns: Dequeued cell for given type
     
     */
    public func dequeueCell<T: ViewReusable & UITableViewCell>(withIdentifier identifier: String? = nil) -> T {
        guard let cell = T.dequeueCell(withTableView: self, withIdentifier: identifier) else {
            fatalError("Cannot dequeue cell \(String(describing: T.self)) with identifier \(identifier ?? T.identifier)")
        }
        return cell
    }
    
    /**
     
     Dequeue a cell from table view with given cell type at given index path.
     
     The cell needs to conform to `TableViewElementReusable` and be of type `UITableViewCell`.
     
     This methods initializes and registers the cell if needed.
     
     - parameter indexPath: Index path of the cell to dequeue
     
     - returns: Dequeued cell for given type
     
     */
    public func dequeueCell<T: ViewReusable & UITableViewCell>(forIndexPath indexPath: IndexPath,
                                                               withIdentifier identifier: String? = nil) -> T {
        guard let cell = T.dequeueCell(withTableView: self, forIndexPath: indexPath, withIdentifier: identifier) else {
            fatalError("Cannot dequeue cell \(String(describing: T.self)) with identifier \(identifier ?? T.identifier)")
        }
        return cell
    }
    
    /**
     
     Dequeue header or footer view from table view
     
     The view needs to conform to `TableViewElementReusable` and be of type `UITableViewHeaderFooterView`.
     
     This methods initializes and registers the view if needed.
     
     - returns: Dequeued view for given type
     
     */
    public func dequeueHeaderFooterView<T: ViewReusable & UITableViewHeaderFooterView>(withIdentifier identifier: String? = nil) -> T {
        guard let view = T.dequeueHeaderFooterView(withTableView: self, withIdentifier: identifier) else {
            fatalError("Cannot dequeue header or footer view \(String(describing: T.self)) with identifier \(identifier ?? T.identifier)")
        }
        return view
    }
 }
 
