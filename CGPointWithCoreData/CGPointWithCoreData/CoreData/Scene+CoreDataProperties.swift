//
//  Scene+CoreDataProperties.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/18.
//
//

import Foundation
import CoreData


extension Scene {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Scene> {
        return NSFetchRequest<Scene>(entityName: "Scene")
    }

    @NSManaged public var points: NSSet?
    @NSManaged public var routeFinding: RouteFinding

}

// MARK: Generated accessors for points
extension Scene {

    @objc(addPointsObject:)
    @NSManaged public func addToPoints(_ value: BodyPoint)

    @objc(removePointsObject:)
    @NSManaged public func removeFromPoints(_ value: BodyPoint)

    @objc(addPoints:)
    @NSManaged public func addToPoints(_ values: NSSet)

    @objc(removePoints:)
    @NSManaged public func removeFromPoints(_ values: NSSet)

}

extension Scene : Identifiable {

}
