//
//  DataListenerDelegate.swift
//  Hager Data Kit
//
//  Created by RGMC on 22/01/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public protocol Listener: class { }

extension NSFetchedResultsController: Listener { }

/**
 Protocol that provide listener methods called on core data CRUD operations
 The core data model needs to be listened with `listen` method first
 */
public protocol DataListenerDelegate: class {
    
    func didChange(object: Any)
    func didInsert(object: Any, at indexPath: IndexPath)
    func didDelete(object: Any, at indexPath: IndexPath)
    func didUpdate(object: Any, at indexPath: IndexPath)
    func didMove(object: Any, from indexPath: IndexPath, to newIndexPath: IndexPath)
    
    func didChange(inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject])
    func didInsert(objects: [NSManagedObject])
    func didUpdate(objects: [NSManagedObject])
    func didDelete(objects: [NSManagedObject])
    
    func contextDidSave()
}

extension DataListenerDelegate {
    
    public func didChange(object: Any) {}
    public func didInsert(object: Any, at indexPath: IndexPath) {}
    public func didDelete(object: Any, at indexPath: IndexPath) {}
    public func didUpdate(object: Any, at indexPath: IndexPath) {}
    public func didMove(object: Any, from indexPath: IndexPath, to newIndexPath: IndexPath) {}
    
    public func didChange(inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject]) {}
    public func didInsert(objects: [NSManagedObject]) {}
    public func didUpdate(objects: [NSManagedObject]) {}
    public func didDelete(objects: [NSManagedObject]) {}
    
    public func contextDidSave() {}
}

extension DataListenerDelegate {
    
    /**
     Imitating the original delegate method from `NSFetchedResultsControllerDelegate` to catch and propagate CRUD operations
     The `NSFetchedResultsControllerDelegate` delegate is implemented by default on NSObject, further implementation is not needed
     */
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        didChange(object: anObject)
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                didInsert(object: anObject, at: indexPath)
            }
            
        case .delete:
            if let indexPath = indexPath {
                didDelete(object: anObject, at: indexPath)
            }
            
        case .update:
            if let indexPath = indexPath {
                didUpdate(object: anObject, at: indexPath)
            }
            
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                didMove(object: anObject, from: indexPath, to: newIndexPath)
            }
        @unknown default: break
        }
    }
}

@available(iOS 10.0, *)
extension DataListenerDelegate {
    
    /**
     Provide a `NSFetchedResultsController` for a core data entity implementing `CoreDataModel` protocol
     This model will be automatically listened and CRUD operations will be propagated through this protocol methods
     */
    public func listen<T: CoreDataModel>(on delegate: NSFetchedResultsControllerDelegate,
                                                    context: NSManagedObjectContext = CoreDataManager.default.context,
                                                    predicate: NSPredicate? = nil,
                                                    sortDescriptors: [NSSortDescriptor] = [],
                                                    sectionNameKeyPath: String? = nil,
                                                    cacheName: String? = nil) -> NSFetchedResultsController<T> {
        
        let fetchRequest: NSFetchRequest<T> = T.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        let fetchedResultController = NSFetchedResultsController<T>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName)
        fetchedResultController.delegate = delegate
    
        do {
            try fetchedResultController.performFetch()
        } catch let error {
            log(.coredata, "Fetch result controller", error: error)
        }
        
        if let delegate = delegate as? NSObject & NSFetchedResultsControllerDelegate {
            NotificationCenter.default.addObserver(delegate, selector: #selector(delegate.contextObjectDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
        }
        
        return fetchedResultController
    }
}


extension NSObject: NSFetchedResultsControllerDelegate {
    
    @objc fileprivate func contextObjectDidChange(notification: Notification) {
        if let delegate = self as? DataListenerDelegate {
            guard let userInfo = notification.userInfo else { return }
            
            var allInserted: [NSManagedObject] = []
            var allDeleted: [NSManagedObject] = []
            var allUpdated: [NSManagedObject] = []
            
            if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
                delegate.didInsert(objects: Array(inserts))
                allInserted.append(contentsOf: Array(inserts))
            }
            
            if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
                delegate.didUpdate(objects: Array(updates))
                allUpdated.append(contentsOf: Array(updates))
            }
            
            if let updates = userInfo[NSRefreshedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
                delegate.didUpdate(objects: Array(updates))
                allUpdated.append(contentsOf: Array(updates))
            }
            
            if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
                delegate.didDelete(objects: Array(deletes))
                allDeleted.append(contentsOf: Array(deletes))
            }
            
            let allChangedObjects = allDeleted + allUpdated + allInserted
            if !allChangedObjects.isEmpty {
                delegate.didChange(inserted: allInserted, updated: allUpdated, deleted: allDeleted)
            }
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let delegate = self as? DataListenerDelegate {
            delegate.controller(controller, didChange: anObject, at: indexPath, for: type, newIndexPath: newIndexPath)
        }
    }
}
