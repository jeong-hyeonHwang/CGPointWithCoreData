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
    
    // MARK: CREATE ROUTE
    func addRoute(routeInfo: RouteInfo) {
        let routeFinding = coreDataDAO.createRouteFindingData(routeInfo: routeInfo) as! RouteFinding
        routeFindingList.append(routeFinding)
    }

    // MARK: UPDATE ROUTE
    func updateRoute(routeInfo: RouteInfo, route: RouteFinding) {
        coreDataDAO.updateRoute(routeInfo: routeInfo, route: route)
    }
    
    // MARK: CREATE PAGE
    func updatePageData(pageInfo: [PageInfo], routeFinding: RouteFinding) {
        print(pageInfo.count)
        for info in pageInfo {
            print("HERE --- ")
            coreDataDAO.createPageData(pageInfo: info, routeFinding: routeFinding)
        }
    }
    
    // MARK: CREATE POINT 포인트 추가
    func updatePointData(pointInfo: [Page : [BodyPointInfo]]) {
        for (key, value) in pointInfo {
            print("hi")
            coreDataDAO.createPointData(bodyPointInfo: value, page: key)
        }
    }
    
    // MARK: UPDATE POINT 기존에 존재하는 포인트를 수정
    func revisePointData(pointInfo: [Page : [(BodyPoint, BodyPointInfo)]]) {
        for (key, value) in pointInfo {
            for pointData in value {
                coreDataDAO.updatePointData(page: key, targetPoint: pointData.0, data: pointData.1)
            }
        }
        coreDataDAO.saveData()
    }
    
    // MARK: DELETE ROUTE
    func deleteRouteData(route: RouteFinding) {
        coreDataDAO.deleteRouteFindingData(routeFinding: route)
        guard let index = routeFindingList.firstIndex(of: route) else { return }
        routeFindingList.remove(at: index)
    }
    
    // MARK: DELETE PAGE
    func deletePagesData(pages: [Page], routeFinding: RouteFinding) {
        coreDataDAO.deletePageData(pages: pages, routeFinding: routeFinding)
    }
    
    // MARK: DELETE POINT
    func deletePointsData(removePointList: [Page : [BodyPoint]]) {
        coreDataDAO.deletePointData(removePointList: removePointList)
    }
    
    
    
    func saveData() {
        coreDataDAO.saveData()
    }
    
    func deleteAllData() {
        coreDataDAO.deleteAllData()
    }
}
