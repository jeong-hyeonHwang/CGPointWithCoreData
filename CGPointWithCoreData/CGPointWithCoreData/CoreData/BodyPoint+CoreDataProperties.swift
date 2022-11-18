//
//  BodyPoint+CoreDataProperties.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/18.
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
    @NSManaged public var primaryPostion: NSObject
    @NSManaged public var secondaryPositon: NSObject?
    @NSManaged public var page: Page

}

extension BodyPoint : Identifiable {

}
