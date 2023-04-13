//
//  TrackingModel.swift
//  XBike
//
//  Created by Ezequiel Rasgido on 13/04/2023.
//

import UIKit
import CoreData

// MARK: - Tracking Model Section

@objc(TrackingModel)
class TrackingModel: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackingModel> {
        return NSFetchRequest<TrackingModel>(entityName: "TrackingModel")
    }

    @NSManaged public var time: String?
    @NSManaged public var streetStart: String?
    @NSManaged public var streetFinish: String?
    @NSManaged public var distance: String?
}

extension TrackingModel : Identifiable {}
