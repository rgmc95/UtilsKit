 //
 //  TableViewCell.swift
 //  UtilsKit
 //
 //  Created by Kévin Mondésir on 28/03/2018.
 //  Copyright © 2018 RGMC. All rights reserved.
 //
 
 import Foundation
 import UIKit
 
 //MARK: - Cell
 extension ViewReusable where Self: UITableViewCell {

    //MARK: Register
    internal static func registerCell(withTableview tableview: UITableView) {
        tableview.register(UINib(nibName: self.nibName, bundle: nil), forCellReuseIdentifier: self.identifier)
    }
    
    //MARK: Dequeue cell with indexpath
    internal static func _dequeueCell(withTableView tableView: UITableView, forIndexPath indexPath: IndexPath) -> Self? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as? Self else {
            return nil
        }
        
        return cell
    }
    
    internal static func dequeueCell(withTableView tableView: UITableView, forIndexPath indexPath: IndexPath) -> Self {
        guard let _ = _dequeueCell(withTableView: tableView) else {
            self.registerCell(withTableview: tableView)
            return _dequeueCell(withTableView: tableView, forIndexPath: indexPath)!
        }
        
        return _dequeueCell(withTableView: tableView, forIndexPath: indexPath)!

    }
    
    //MARK: Dequeue cell without indexpath
    internal static func _dequeueCell(withTableView tableView: UITableView) -> Self? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier) as? Self else {
            return nil
        }
        
        return cell
    }
    
    internal static func dequeueCell(withTableView tableView: UITableView) -> Self {
        guard let cell = _dequeueCell(withTableView: tableView) else {
            self.registerCell(withTableview: tableView)
            return _dequeueCell(withTableView: tableView)!
        }
        
        return cell
    }
 }
 
 //MARK: - Header/Footer
 extension ViewReusable where Self: UITableViewHeaderFooterView {
    
    //MARK: Register
    internal static func registerHeaderFooterView(withTableview tableview: UITableView) {
        tableview.register(UINib(nibName: self.nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: self.identifier)
    }
    
    //MARK: Dequeue header or footer view
    internal static func _dequeueHeaderFooterView(withTableView tableView: UITableView) -> Self? {
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.identifier) as? Self else {
            return nil
        }
        
        return cell
    }
    
    internal static func dequeueHeaderFooterView(withTableView tableView: UITableView) -> Self {
        guard let cell = _dequeueHeaderFooterView(withTableView: tableView) else {
            self.registerHeaderFooterView(withTableview: tableView)
            return _dequeueHeaderFooterView(withTableView: tableView)!
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
    public func dequeueCell<T: ViewReusable & UITableViewCell>(_ type: T.Type) -> T {
        return T.dequeueCell(withTableView: self)
    }
    
    /**
     
     Dequeue a cell from table view with given cell type at given index path.
     
     The cell needs to conform to `TableViewElementReusable` and be of type `UITableViewCell`.
     
     This methods initializes and registers the cell if needed.
     
     - parameter type: Type of the cell to dequeue
     - parameter indexPath: Index path of the cell to dequeue
     
     - returns: Dequeued cell for given type
     
     */
    public func dequeueCell<T: ViewReusable & UITableViewCell>(_ type: T.Type, forIndexPath indexPath: IndexPath) -> T {
        return T.dequeueCell(withTableView: self, forIndexPath: indexPath)
    }
    
    /**
     
     Dequeue header or footer view from table view
     
     The view needs to conform to `TableViewElementReusable` and be of type `UITableViewHeaderFooterView`.
     
     This methods initializes and registers the view if needed.
     
     - parameter type: Type of the view to dequeue
     
     - returns: Dequeued view for given type
     
     */
    public func dequeueHeaderFooterView<T: ViewReusable & UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        return T.dequeueHeaderFooterView(withTableView: self)
    }
 }
 
