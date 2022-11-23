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
    @NSManaged public var pages: NSSet?

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
    func returnRouteInfo() -> RouteInfo {
        let pageArray = Array(self.pages as! Set<Page>)
        var pageInfo: [PageInfo] = []
        var points2dimensionArray: [[BodyPointInfo]] = []
        for i in 0..<pageArray.count {
            let pointsArray = Array(pageArray[i].points as! Set<BodyPoint>)
            var pointInfo: [BodyPointInfo] = []
            for j in 0..<pointsArray.count {
                let temp = BodyPointInfo(footOrHand: FootOrHand(rawValue: pointsArray[j].footOrHand) ?? FootOrHand.hand, isForce: pointsArray[j].isForce, primaryPosition: CGPoint(x: pointsArray[j].primaryXCoordinate, y: pointsArray[j].primaryYCoordinate), secondaryPosition: CGPoint(x: pointsArray[j].secondaryXCoordinate, y: pointsArray[j].secondaryYCoordinate))
                pointInfo.append(temp)
            }
            points2dimensionArray.append(pointInfo)
            pageInfo.append(PageInfo(rowOrder: Int(pageArray[i].rowOrder), points: points2dimensionArray[i]))
        }
        
        return RouteInfo(dataWrittenDate: self.dataWrittenDate, gymName: self.gymName, problemLevel: Int(self.problemLevel), isChallengeComplete: self.isChallengeComplete, pages: pageInfo)
    }
}
