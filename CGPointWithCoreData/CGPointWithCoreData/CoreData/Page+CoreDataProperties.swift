//
//  Page+CoreDataProperties.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/19.
//
//

import Foundation
import CoreData


extension Page {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Page> {
        return NSFetchRequest<Page>(entityName: "Page")
    }

    @NSManaged public var rowOrder: Int16
    @NSManaged public var points: NSSet?
    @NSManaged public var routeFinding: RouteFinding

}

// MARK: Generated accessors for points
extension Page {

    @objc(addPointsObject:)
    @NSManaged public func addToPoints(_ value: BodyPoint)

    @objc(removePointsObject:)
    @NSManaged public func removeFromPoints(_ value: BodyPoint)

    @objc(addPoints:)
    @NSManaged public func addToPoints(_ values: NSSet)

    @objc(removePoints:)
    @NSManaged public func removeFromPoints(_ values: NSSet)

}

extension Page : Identifiable {

}
