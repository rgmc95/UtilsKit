//
//  Listener.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 07/05/2020.
//  Copyright © 2020 iD.apps. All rights reserved.
//

import Foundation
import CoreData

public protocol Listener: AnyObject { }

extension NSFetchedResultsController: Listener { }
