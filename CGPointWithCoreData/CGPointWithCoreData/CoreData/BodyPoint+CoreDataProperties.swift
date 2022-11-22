//
//  BodyPoint+CoreDataProperties.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/22.
//
//

import Foundation
import CoreData


extension BodyPoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BodyPoint> {
        return NSFetchRequest<BodyPoint>(entityName: "BodyPoint")
    }

    @NSManaged public var footOrHand: String
    @NSManaged public var isForce: Bool
    @NSManaged public var primaryXCoordinate: Double
    @NSManaged public var primaryYCoordinate: Double
    @NSManaged public var secondaryXCoordinate: Double
    @NSManaged public var secondaryYCoordinate: Double
    @NSManaged public var id: UUID?
    @NSManaged public var page: Page?

}

extension BodyPoint : Identifiable {

}
