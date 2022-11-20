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
    
    private var repository: DataRepository
    private var coreDataDAO: CoreDataDAO
    
    init() {
        repository = DataRepository()
        coreDataDAO = CoreDataDAO()
        updateRepository()
    }
    
    // CoreData 정보를 DataRepository의 routeFindingList에 할당
    func updateRepository() {
        repository.routeFindingList = coreDataDAO.readRouteFindingData()
    }
    
    func routeFindingList() -> [RouteFinding] {
        return repository.routeFindingList
    }
    
    func addRoute(routeInfo: RouteInfo) {
        let routeFinding = coreDataDAO.createRouteFindingData(routeInfo: routeInfo) as! RouteFinding
        repository.routeFindingList.append(routeFinding)
    }

    func updatePageData(pageInfo: [PageInfo], routeFinding: RouteFinding){
        for info in pageInfo {
            coreDataDAO.createPageData(pageInfo: info, routeFinding: routeFinding)
        }
    }
    
    func updatePointData(pointInfo: [(Page, [BodyPointInfo])]){
        for info in pointInfo {
            for bodyPoint in info.1 {
                coreDataDAO.createPointData(bodyPointInfo: bodyPoint, page: info.0)
            }
        }
    }
    
    func saveData() {
        coreDataDAO.saveData()
    }
    
    func deleteAllData() {
        coreDataDAO.deleteAllData()
    }
}
