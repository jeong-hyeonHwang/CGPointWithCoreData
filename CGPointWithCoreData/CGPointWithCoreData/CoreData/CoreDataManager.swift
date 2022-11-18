//
//  CoreDataManager.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/18.
//

import UIKit
import CoreData

class CoreDataManager {

     static let shared = CoreDataManager()
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appDelegate.persistentContainer.viewContext

    init() { }
    
    // R 구조체를 매개변수로 받아 RouteFinding NSManagedObject에 추가
    func createRouteFindingData(info: Route) -> NSManagedObject {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "RouteFinding", into: context)
        
        entity.setValue(UUID(), forKey: "id")
        entity.setValue(info.gymName, forKey: "gymName")
        entity.setValue(info.dataWrittenDate, forKey: "dataWrittenDate")
        entity.setValue(info.problemLevel, forKey: "problemLevel")
        entity.setValue(info.isChallengeComplete, forKey: "isChallengeComplete")
        
        saveData()
        
        return entity
    }
    
    func createPageData(rowOrder: Int, routeFinding: RouteFinding) -> Page {        let page = Page(context: context)
        page.rowOrder = Int16(rowOrder)
        routeFinding.addToPages(page)
        
        return page
    }
    
    func createPointData(point: BodyPoint, scene: Page) -> BodyPoint {
        let bodyPoint = BodyPoint(context: context)
        scene.addToPoints(bodyPoint)
        
        return bodyPoint
    }
    
    // Core Data의 읽어 RouteFinding 클래스를 반환합니다.
    func readRouteFindingData() -> [RouteFinding] {
        let request = RouteFinding.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dataWrittenDate", ascending: true)]
        var information: [RouteFinding] = []
        do {
            information = try context.fetch(request)
            
        } catch {
            print("CoreDataManager ReadData Method \(error.localizedDescription)")
        }
        
        return information
    }
    
    // Core Data의 읽어 RouteFinding 클래스를 반환합니다.
    func readPageData(routeFinding: RouteFinding) -> [Page] {
        let request = Page.fetchRequest()
        request.predicate = NSPredicate(format: "routeFinding = %@", routeFinding)
        
        var information: [Page] = []
        
        do {
            information = try context.fetch(request)
        } catch {
            print("CoreDataManager ReadData Method \(error.localizedDescription)")
        }
        
        return information
    }
    
    // 단일 데이터 삭제를 위한 메소드
    func deleteData(routeFinding: RouteFinding) {
        
        guard let id = routeFinding.id else { return }
        let request = RouteFinding.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let info = try context.fetch(request)
            if let tempInfo = info.first {
                context.delete(tempInfo)
            }
        } catch {
            print("CoreDataManager DeleteData Method \(error.localizedDescription)")
        }
        saveData()
    }
    
    // 전체 데이터 삭제를 위한 메소드
    func deleteAllData() {
        let objects = readRouteFindingData()
        
        if objects.count > 0 {
            for object in objects {
                context.delete(object)
            }
            saveData()
        }
    }
    
    // 추가한 데이터를 현재 context에 반영
    func saveData() {
        do {
            try context.save()
        } catch {
            print("CoreDataManager SaveData Method \(error.localizedDescription)")
        }
    }
}
