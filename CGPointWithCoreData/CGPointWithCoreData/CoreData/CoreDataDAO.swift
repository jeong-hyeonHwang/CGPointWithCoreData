//
//  CoreDataDAO.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/18.
//

import UIKit
import CoreData

class CoreDataDAO {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appDelegate.persistentContainer.viewContext
    
    init() { }
    
    // R 구조체를 매개변수로 받아 RouteFinding NSManagedObject에 추가
    func createRouteFindingData(info: RouteFinding) -> NSManagedObject {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "RouteFinding", into: context)
        
        entity.setValue(UUID(), forKey: "id")
        entity.setValue(info.gymName, forKey: "gymName")
        entity.setValue(info.dataWrittenDate, forKey: "dataWrittenDate")
        entity.setValue(info.problemLevel, forKey: "problemLevel")
        entity.setValue(info.isChallengeComplete, forKey: "isChallengeComplete")
        
        saveData()
        
        return entity
    }
    
    func createSceneData(routeFinding: RouteFinding) -> Scene {
        let scene = Scene(context: context)
        routeFinding.addToScenes(scene)
        
        return scene
    }
    
    func createPointData(point: BodyPoint, scene: Scene) -> BodyPoint {
        let bodyPoint = BodyPoint(context: context)
        scene.addToPoints(bodyPoint)
        
        return bodyPoint
    }
    
    // Core Data의 읽어 RouteFinding 클래스를 반환합니다.
    func readData() -> [RouteFinding] {
        var information: [RouteFinding] = []
        
        do {
            information = try context.fetch(RouteFinding.fetchRequest())
        } catch {
            print("CoreDataDAO ReadData Method \(error.localizedDescription)")
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
            print("CoreDataDAO DeleteData Method \(error.localizedDescription)")
        }
        saveData()
    }
    
    // 전체 데이터 삭제를 위한 메소드
    func deleteAllData() {
        let objects = readData()
        
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
            print("CoreDataDAO SaveData Method \(error.localizedDescription)")
        }
    }
}
