//
//  CoreDataManager.swift
//  Hager Data Kit
//
//  Created by RGMC on 12/01/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//
import Foundation
import CoreData
import UIKit

/**
 Wrapper class to easily manage core data and entities with `CoreDataModel` protocol
 The context is managed by this class:
 - On the main thread, the main context is used
 - On background thread, a background context is used; created if it doesn't exist and persistent until it is purged with `save` method
 As long as the background context is not purged, it will remain the only one on the thread
 */
@available(iOS 10.0, *)
final public class CoreDataManager {
    
    /**
     Shared instance
     */
    public static var `default` = CoreDataManager()
    
    /**
     Set the core data stack
     - parameter model : Name of the `xcdatamodel`
     */
    public func setCoreDataStack(_ name: String, bundleId: String? = nil) {
        if let bundleId = bundleId {
            let modelURL = Bundle(identifier: bundleId)!.url(forResource: name, withExtension: "momd")!
            persistentContainer = NSPersistentContainer(name: name, managedObjectModel: NSManagedObjectModel(contentsOf: modelURL)!)
        } else {
            persistentContainer = NSPersistentContainer(name: name)
        }
        persistentContainer.loadPersistentStores(completionHandler: { [weak self] (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            self?.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            self?.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        })
    }
    
    //MARK: - Core Data stack
    fileprivate var persistentContainer: NSPersistentContainer!
    
    //MARK: - Background Contexts
    private let backgroundGroup = DispatchGroup()
    private let backgroundContextsAccessQueue: DispatchQueue! = DispatchQueue( label: "backgroundContextsAccessQueue")
    private var _backgroundContexts: [String: NSManagedObjectContext] = [:]
    private var backgroundContexts: [String: NSManagedObjectContext]! {
        set(newValue){
            backgroundContextsAccessQueue.sync(){ [weak self] in
                self?._backgroundContexts = newValue
            }
        }
        get{
            return backgroundContextsAccessQueue.sync{
                _backgroundContexts
            }
        }
    }
    
}

// MARK: - Core Data contexts management
@available(iOS 10.0, *)
extension CoreDataManager {
    
    /**
     Create a context in a background thread and it in background contexts stack
     Attach an id to the context to allow only one context per thread
     */
    private func createNewBackgroundContext() -> NSManagedObjectContext {
        let newContext = persistentContainer.newBackgroundContext()
        let token = Thread.current.id
        
        newContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        self.backgroundContexts[token] = newContext

        return newContext
    }
    
    /**
     - returns: If the current thread is the main thread, return the main context, otherwise return the background context corresponding to the thread
     */
    public var context: NSManagedObjectContext {
        defer {
            self.backgroundGroup.leave()
        }
        self.backgroundGroup.wait()
        self.backgroundGroup.enter()
        
        if Thread.current.isMainThread { return self.persistentContainer.viewContext }
        
        if let backgroundContext = self.self.backgroundContexts[Thread.current.id] {
            return backgroundContext
        } else {
            return createNewBackgroundContext()
        }
    }
    
    /**
     Save the current context
     - parameter purge : wether the context needs to be purge or not. Works only for background context
     */
    public func save(purge: Bool = true) throws {
        var _error: Error? = nil
        let isMainContext = self.persistentContainer.viewContext == self.context
        
        if self.context.hasChanges {
            self.performAndWait { [weak self] in
                do {
                    try self?.context.save()
                } catch {
                    _error = error
                    log(.coredata, "\(isMainContext ? "Main" : "Background") context saved", error: error)
                }
            }
            
            if let error = _error {
                throw error
            }
            
            // Purge background context if needed
            if purge { self.backgroundContexts.removeValue(forKey: Thread.current.id) }
        }
        
        log(.coredata, "\(isMainContext ? "Main" : "Background") context saved")
    }
    
    /**
     Save the current context and log error if exist
     - parameter purge : wether the context needs to be purge or not. Works only for background context
     */
    public func save(purge: Bool = true, errorCompletion: ((Error)->())?) {
        do { try save(purge: purge) }
        catch { errorCompletion?(error) }
    }
}

//MARK: - Core Data FETCH requests
@available(iOS 10.0, *)
extension CoreDataManager {
    
    // Fetch with predicate
    fileprivate func fetch<T: NSManagedObject>(entity: String, with predicate: NSPredicate? = nil) -> [T] {
        var objects: [T]?
        
        self.performAndWait { [weak self] in
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
            fetchRequest.predicate = predicate
            objects = (try? self?.context.fetch(fetchRequest)) as? [T]
        }
        
        return objects ?? []
    }
    
    fileprivate func fetch<T: CoreDataModel>(predicate: NSPredicate? = nil) -> [T] {
        return self.fetch(entity: T.entityName, with: predicate)
    }
    
    // Fetch with primary key
    fileprivate func fetch<T: CoreDataModel>(with primaryKey: PrimaryKey) -> [T] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: T.entityName)
        fetchRequest.predicate = T.predicate(with: primaryKey)
        
        return (try? self.context.fetch(fetchRequest)) as? [T] ?? []
    }
    
    // Fetch first with predicate
    fileprivate func fetchFirst<T: NSManagedObject>(entity: String, with predicate: NSPredicate? = nil) -> T? {
        return self.fetch(entity: entity, with: predicate).first
    }
    
    fileprivate func fetchFirst<T: CoreDataModel>(predicate: NSPredicate? = nil) -> T? {
        return self.fetchFirst(entity: T.entityName, with: predicate)
    }
    
    // Fetch first with primary key
    fileprivate func fetchFirst<T: CoreDataModel>(with primaryKey: PrimaryKey) -> T? {
        return self.fetch(with: primaryKey).first
    }
    
    // Create
    fileprivate func create<T: CoreDataModel>() -> T? {
        var object: T?
        
        self.performAndWait { [weak self] in
            guard let self = self else { return }
            object = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self.context) as? T
        }
        
        return object
    }
    
    fileprivate func fetchOrCreate<T: CoreDataModel>(with primaryKey: PrimaryKey) -> T? {
        if let object: T = self.fetch(with: primaryKey).first {
            return object
        }
        
        var object: T?
        
        self.performAndWait { [weak self] in
            guard let self = self else { return }
            object = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self.context) as? T
            object?.setValue(primaryKey , forKey: T.primaryKey)
        }
       
        
        return object
    }
}

//MARK: - Core Data DELETE requests
@available(iOS 10.0, *)
extension CoreDataManager {
    
    internal func performAndWait(_ block: ()->()) {
        let context = self.context
        let masterThreadId = Thread.current.id
        
        self.context.performAndWait { [weak self] in
            self?.backgroundContexts[Thread.current.id] = context
            block()
            if masterThreadId != Thread.current.id {
                self?.backgroundContexts.removeValue(forKey: Thread.current.id)
            }
        }
    }
    
    // Delete one object
    fileprivate func delete<T: NSManagedObject>(object: T) {
        self.performAndWait { [weak self] in
            self?.context.delete(object)
        }
    }
    
    fileprivate func delete<T: CoreDataModel>(with primaryKey: PrimaryKey) -> [T] {
        if let object: T = fetchOrCreate(with: primaryKey) { delete(object: object) }
        return fetch()
    }
    
    // Delete with predicate
    fileprivate func delete<T: NSManagedObject>(predicate: NSPredicate? = nil, entity: String) -> [T] {
        let objects: [T] = fetch(entity: entity, with: predicate)
        
        objects.forEach{[weak self] in self?.context.delete($0)}
        
        return fetch(entity: entity)
    }
    
    fileprivate func delete<T: CoreDataModel>(predicate: NSPredicate? = nil) -> [T] {
        return self.delete(predicate: predicate, entity: T.entityName)
    }
    
    /**
     Drop the entire database
     */
    public func dropDatabase() throws {
        self.persistentContainer.managedObjectModel.entities.forEach({ [weak self] entity in
            _ = self?.delete(predicate: nil, entity: entity.name!)
            do {
                try self?.persistentContainer.viewContext.save()
                log(.coredata, "Database droped")
            } catch {
                log(.coredata, "Drop Database", error: error)
            }
        })
    }
}

//MARK: - Core Data Model extension
@available(iOS 10.0, *)
extension CoreDataModel {
    
    /**
     Create a basic fetch request
     - returns: a fetch request based on the entity's name
     */
    static public func fetchRequest() -> NSFetchRequest<Self> {
        return NSFetchRequest<Self>(entityName: self.entityName)
    }
    
    /**
     Create a basic predicate
     - parameter primaryKey: primary key of the entity
     - returns: a predicate based on the given primary key
     */
    static public func predicate(with primaryKey: PrimaryKey) -> NSPredicate {
        return NSPredicate(format: "\(Self.primaryKey) = \(primaryKey.type)", primaryKey)
    }
    
    // MARK: Core Data Model GET
    
    /**
     Create an entity
     - returns: the instance of the created entity or nil
     */
    static public func create() -> Self? {
        return CoreDataManager.default.create()
    }
    
    /**
     Find an entity based on the given primary key if it exists, otherwise create it
     - parameter primaryKey: primary key of the entity to find
     - returns: the instance of the found or created entity
     */
    static public func findOrCreate(with primaryKey: PrimaryKey?) -> Self? {
        guard let primaryKey = primaryKey else { return nil }
        return CoreDataManager.default.fetchOrCreate(with: primaryKey)
    }
    
    /**
     Get all entities compliant with the given predicate
     - parameter predicate: a predicate or nil
     - returns: all found entities
     */
    static public func getAll(predicate: NSPredicate? = nil) -> [Self] {
        return CoreDataManager.default.fetch(predicate: predicate)
    }
    
    /**
     Get the entity corresponding to the given primary key
     - parameter primaryKey: primary key of the entity to find
     - returns: the instance of the found entity or nil if not found
     */
    static public func get(with primaryKey: PrimaryKey?) -> Self? {
        guard let primaryKey = primaryKey else { return nil }
        return CoreDataManager.default.fetch(with: primaryKey).first
    }
    
    /**
     Get the entities corresponding to the given primary keys
     - parameter primaryKeys: primary keys of the entities to find
     - returns: all found entities
     */
    static public func getAll(with primaryKeys: [PrimaryKey]) -> [Self] {
        return self.getAll(predicate: NSPredicate(format: "\(Self.primaryKey) IN %@", primaryKeys))
    }
    
    /**
     Delete the entity corresponding to the given primary key
     - parameter primaryKey: primary key of the entity to delete
     - returns: the remaining entities
     */
    @discardableResult static public func delete(with primaryKey: PrimaryKey) -> [Self] {
        return CoreDataManager.default.delete(with: primaryKey)
    }
    
    /**
     Delete the entity corresponding to the given predicate
     - parameter predicate: the predicate of the entities to delete
     - returns: all remaining entities
     */
    @discardableResult static public func deleteAll(predicate: NSPredicate? = nil) -> [Self] {
        return CoreDataManager.default.delete(predicate: predicate)
    }
    
    /**
     Delete all entities except given primary keys
     - parameter except: primary keys of the entities to keep
     - returns: all remaining entities
     */
    @discardableResult static public func deleteAll(except primaryKeys: [PrimaryKey]) -> [Self] {
        return self.deleteAll(predicate: NSPredicate(format: "NOT \(Self.primaryKey) IN %@", primaryKeys))
    }
    
    /**
     Decode and save entity in current context
     */
    static public func update(with data: Any) -> Self? {
        var object: Self?
        
        CoreDataManager.default.performAndWait {
            do {
                object = try self.decode(with: data)
            } catch { log(.coredata, "Update \(Self.entityName)", error: error)}
        }
        
        return object
    }
}

@available(iOS 10.0, *)
extension Array: CoreDataUpdatable where Element: CoreDataModel {
    
    /**
     Perform `decode` method from `CoreDataModel` protocol on every element contained in the array and save entities in current context
     */
    static public func update(with data: Any) -> [Element]? {
        guard let data = data as? [Any] else { return nil }
        
        var objects: [Element?] = []
        
        CoreDataManager.default.performAndWait {
            do {
                for dataElement in data { objects.append(try Element.decode(with: dataElement)) }
            } catch { log(.coredata, "Update \(Element.entityName)", error: error)}
        }
        
        return objects.compactMap({$0})
    }
    
    
    /**
     Perform `decode` method from `CoreDataModel` protocol on every element contained in the array
     */
    static public func decode(with data: Any) throws -> [Element]? {
        guard let data = data as? [Any] else { return nil }
        
        var objects: [Element?] = []
        var error: Error?
        
        CoreDataManager.default.performAndWait {
            do {
                for dataElement in data { objects.append(try Element.decode(with: dataElement)) }
            } catch let e { error = e }
        }
        
        if let error = error { throw error }
        
        return objects.compactMap({$0})
    }
}

@available(iOS 10.0, *)
extension NSManagedObject {
    
    /**
     Get all entities compliant with the given predicate using `CoreDataManager` class
     - parameter entity: the name of the core data model
     - parameter predicate: a predicate or nil
     - returns: all found entities
     */
    static public func getAll<T: NSManagedObject>(entity: String, with predicate: NSPredicate? = nil) -> [T] {
        return CoreDataManager.default.fetch(entity: entity, with: predicate)
    }
    
    /**
     Delete the entity using `CoreDataManager` class
     */
    public func delete() {
        return CoreDataManager.default.delete(object: self)
    }
    
    /**
     Delete the entity corresponding to the given predicate using `CoreDataManager` class
     - parameter predicate: the predicate of the entities to delete
     - parameter entity: the name of the core data model
     - returns: all deleted entities
     */
    static public func deleteAll(entity: String, with predicate: NSPredicate? = nil) -> [NSManagedObject] {
        return CoreDataManager.default.delete(predicate: predicate, entity: entity)
    }
}
