//
//  CoreDataManager.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/18.
//

import UIKit
import CoreData

final class DataManager {
    
    static var shared = DataManager()
    
    private var coreDataDAO: CoreDataDAO
    private var routeFindingList: [RouteFinding] = []
    init() {
        coreDataDAO = CoreDataDAO()
        updateRepository()
    }
    
    // CoreData 정보를 DataRepository의 routeFindingList에 할당
    func updateRepository() {
        routeFindingList = coreDataDAO.readRouteFindingData()
    }
    
    func getRouteFindingList() -> [RouteFinding] {
        return routeFindingList
    }
    
    func addRoute(routeInfo: RouteInfo) {
        let routeFinding = coreDataDAO.createRouteFindingData(routeInfo: routeInfo) as! RouteFinding
        routeFindingList.append(routeFinding)
    }

    func updatePageData(pageInfo: [PageInfo], routeFinding: RouteFinding) {
        print(pageInfo.count)
        for info in pageInfo {
            print("HERE --- ")
            coreDataDAO.createPageData(pageInfo: info, routeFinding: routeFinding)
        }
    }
    
    func updatePointData(pointInfo: [Page : [BodyPointInfo]]) {
        for (key, value) in pointInfo {
            print("hi")
            coreDataDAO.createPointData(bodyPointInfo: value, page: key)
        }
    }
    
    func deletePagesData(pages: [Page], routeFinding: RouteFinding) {
        coreDataDAO.deletePageData(pages: pages, routeFinding: routeFinding)
    }
    
    func deletePointsData(removePointList: [Page : [BodyPoint]]) {
        coreDataDAO.deletePointData(removePointList: removePointList)
    }
    
    func deleteRouteData(route: RouteFinding) {
        coreDataDAO.deleteRouteFindingData(routeFinding: route)
        let indices = routeFindingList.filter({ $0 == route }).indices
        if indices.count > 0 {
            routeFindingList.remove(at: indices[0])
        }
    }
    
    func saveData() {
        coreDataDAO.saveData()
    }
    
    func deleteAllData() {
        coreDataDAO.deleteAllData()
    }
}
