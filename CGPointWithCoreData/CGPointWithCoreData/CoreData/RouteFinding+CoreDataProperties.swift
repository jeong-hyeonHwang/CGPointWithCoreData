//
//  RouteFinding+CoreDataProperties.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/22.
//
//

import Foundation
import CoreData


extension RouteFinding {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RouteFinding> {
        return NSFetchRequest<RouteFinding>(entityName: "RouteFinding")
    }

    @NSManaged public var dataWrittenDate: Date
    @NSManaged public var gymName: String
    @NSManaged public var id: UUID?
    @NSManaged public var isChallengeComplete: Bool
    @NSManaged public var problemLevel: Int16
    @NSManaged public var pages: NSSet

}

// MARK: Generated accessors for pages
extension RouteFinding {

    @objc(addPagesObject:)
    @NSManaged public func addToPages(_ value: Page)

    @objc(removePagesObject:)
    @NSManaged public func removeFromPages(_ value: Page)

    @objc(addPages:)
    @NSManaged public func addToPages(_ values: NSSet)

    @objc(removePages:)
    @NSManaged public func removeFromPages(_ values: NSSet)

}

extension RouteFinding : Identifiable {

}
