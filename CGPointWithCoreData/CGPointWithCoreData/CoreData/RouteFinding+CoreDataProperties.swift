//
//  RouteFinding+CoreDataProperties.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/18.
//
//

import Foundation
import CoreData


extension RouteFinding {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RouteFinding> {
        return NSFetchRequest<RouteFinding>(entityName: "RouteFinding")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var dataWrittenDate: Date
    @NSManaged public var gymName: String
    @NSManaged public var problemLevel: Int16
    @NSManaged public var isChallengeComplete: Bool
    @NSManaged public var scenes: NSSet?

}

// MARK: Generated accessors for scenes
extension RouteFinding {

    @objc(addScenesObject:)
    @NSManaged public func addToScenes(_ value: Scene)

    @objc(removeScenesObject:)
    @NSManaged public func removeFromScenes(_ value: Scene)

    @objc(addScenes:)
    @NSManaged public func addToScenes(_ values: NSSet)

    @objc(removeScenes:)
    @NSManaged public func removeFromScenes(_ values: NSSet)

}

extension RouteFinding : Identifiable {

}
