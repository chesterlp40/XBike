//
//  CoreDataManager.swift
//  XBike
//
//  Created by Ezequiel Rasgido on 13/04/2023.
//

import CoreData

// MARK: - CoreDataManager Section

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    static let sharedInstance: CoreDataManager = CoreDataManager()
    
    private init() {
        self.persistentContainer = NSPersistentContainer(
            name: "TrackingDataModel"
        )
        self.persistentContainer.loadPersistentStores { description, error in
            if let safeError = error {
                fatalError("Unable to initialize Core Data. \(safeError)")
            }
        }
    }
}
