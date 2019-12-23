 //
 //  TableViewCell.swift
 //  UtilsKit
 //
 //  Created by RGMC on 28/03/2018.
 //  Copyright © 2018 RGMC. All rights reserved.
 //
 
 import Foundation
 import UIKit
 
 //MARK: - Cell
 extension ViewReusable where Self: UITableViewCell {

    //MARK: Register
    internal static func registerCell(withTableview tableview: UITableView, forCellReuseIdentifier identifier: String? = nil) {
        guard let nibName = self.nibName else { return }
        tableview.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: identifier ?? self.identifier)
    }
    
    //MARK: Dequeue cell with indexpath
    internal static func _dequeueCell(withTableView tableView: UITableView, forIndexPath indexPath: IndexPath, withIdentifier identifier: String? = nil) -> Self? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier ?? self.identifier, for: indexPath) as? Self else {
            return nil
        }
        
        return cell
    }
    
    internal static func dequeueCell(withTableView tableView: UITableView, forIndexPath indexPath: IndexPath, withIdentifier identifier: String? = nil) -> Self {
        guard let _ = _dequeueCell(withTableView: tableView, withIdentifier: identifier) else {
            self.registerCell(withTableview: tableView, forCellReuseIdentifier: identifier)
            return _dequeueCell(withTableView: tableView, forIndexPath: indexPath, withIdentifier: identifier)!
        }
        
        return _dequeueCell(withTableView: tableView, forIndexPath: indexPath, withIdentifier: identifier)!

    }
    
    //MARK: Dequeue cell without indexpath
    internal static func _dequeueCell(withTableView tableView: UITableView, withIdentifier identifier: String? = nil) -> Self? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier ?? self.identifier) as? Self else {
            return nil
        }
        
        return cell
    }
    
    internal static func dequeueCell(withTableView tableView: UITableView, withIdentifier identifier: String? = nil) -> Self {
        guard let cell = _dequeueCell(withTableView: tableView, withIdentifier: identifier) else {
            self.registerCell(withTableview: tableView, forCellReuseIdentifier: identifier)
            return _dequeueCell(withTableView: tableView, withIdentifier: identifier)!
        }
        
        return cell
    }
 }
 
 //MARK: - Header/Footer
 extension ViewReusable where Self: UITableViewHeaderFooterView {
    
    //MARK: Register
    internal static func registerHeaderFooterView(withTableview tableview: UITableView, withIdentifier identifier: String? = nil) {
        guard let nibName = Self.nibName else { return }
        tableview.register(UINib(nibName: nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier ?? self.identifier)
    }
    
    //MARK: Dequeue header or footer view
    internal static func _dequeueHeaderFooterView(withTableView tableView: UITableView, withIdentifier identifier: String? = nil) -> Self? {
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier ?? self.identifier) as? Self else {
            return nil
        }
        
        return cell
    }
    
    internal static func dequeueHeaderFooterView(withTableView tableView: UITableView, withIdentifier identifier: String? = nil) -> Self {
        guard let cell = _dequeueHeaderFooterView(withTableView: tableView, withIdentifier: identifier) else {
            self.registerHeaderFooterView(withTableview: tableView, withIdentifier: identifier)
            return _dequeueHeaderFooterView(withTableView: tableView, withIdentifier: identifier)!
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
    public func dequeueCell<T: ViewReusable & UITableViewCell>(_ type: T.Type, withIdentifier identifier: String? = nil) -> T {
        return T.dequeueCell(withTableView: self, withIdentifier: identifier)
    }
    
    /**
     
     Dequeue a cell from table view with given cell type at given index path.
     
     The cell needs to conform to `TableViewElementReusable` and be of type `UITableViewCell`.
     
     This methods initializes and registers the cell if needed.
     
     - parameter type: Type of the cell to dequeue
     - parameter indexPath: Index path of the cell to dequeue
     
     - returns: Dequeued cell for given type
     
     */
    public func dequeueCell<T: ViewReusable & UITableViewCell>(_ type: T.Type, forIndexPath indexPath: IndexPath, withIdentifier identifier: String? = nil) -> T {
        return T.dequeueCell(withTableView: self, forIndexPath: indexPath, withIdentifier: identifier)
    }
    
    /**
     
     Dequeue header or footer view from table view
     
     The view needs to conform to `TableViewElementReusable` and be of type `UITableViewHeaderFooterView`.
     
     This methods initializes and registers the view if needed.
     
     - parameter type: Type of the view to dequeue
     
     - returns: Dequeued view for given type
     
     */
    public func dequeueHeaderFooterView<T: ViewReusable & UITableViewHeaderFooterView>(_ type: T.Type, withIdentifier identifier: String? = nil) -> T {
        return T.dequeueHeaderFooterView(withTableView: self, withIdentifier: identifier)
    }
 }
 
