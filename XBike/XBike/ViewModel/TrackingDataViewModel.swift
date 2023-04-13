//
//  TrackingDataViewModel.swift
//  XBike
//
//  Created by Ezequiel Rasgido on 13/04/2023.
//

import UIKit
import CoreData

// MARK: - TrackingDataViewModel Section

class TrackingDataViewModel {
    
    private var context = CoreDataManager.sharedInstance.persistentContainer.viewContext
    internal var trackingData: [TrackingModel] = []
    
    internal func fetchInfo() {
        let request: NSFetchRequest<TrackingModel> = NSFetchRequest(
            entityName: "TrackingModel"
        )
        do {
            self.trackingData = try self.context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    internal func saveData(
        _ time: String,
        _ streetStart: String,
        _ streetFinish: String,
        _ distance: String
    ) {
        let trackingModel = TrackingModel(
            context: self.context
        )
        trackingModel.time = time
        trackingModel.streetStart = streetStart
        trackingModel.streetFinish = streetFinish
        trackingModel.distance = distance
        
        try? self.context.save()
    }
}
