//
//  Operations.swift
//  UtilsKit
//
//  Created by RGMC on 18/10/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

/**
 Operation wrapper inheriting from Foundation.Operation managing execution with observers
 */
open class Operation: Foundation.Operation {
    
    fileprivate var _executing: Bool = false
    
    /**
     Indicates if the current operation is executing
     Get & set
     */
    override open var isExecuting: Bool {
        get {
            return _executing
        }
        set {
            self.willChangeValue(forKey: "isExecuting")
            _executing = newValue
            self.didChangeValue(forKey: "isExecuting")
        }
    }
    
    fileprivate var _finished: Bool = false
    
    /**
     Indicates if the current operation is finished
     Get & set
     */
    override open var isFinished: Bool {
        get {
            return _finished
        }
        set {
            self.willChangeValue(forKey: "isFinished")
            _finished = newValue
            self.didChangeValue(forKey: "isFinished")
        }
    }
}


/**
 Identifiable operation
 */
open class IdentifiableOperation: Operation {
    
    /**
     Linked `Identifiable` to the operation
     */
    public var identifiables: [Identifiable] = []
    
    /**
     Init the operation with a single identifiable
     */
    public init(identifiable: Identifiable? = nil) {
        if let identifiable = identifiable { self.identifiables.append(identifiable) }
        super.init()
    }
    
    override open func main() {
        super.main()
        self.isExecuting = true
    }
    
    override open func start() {
        if isCancelled {
            self.isFinished = true
            return
        }
        super.start()
    }
}
