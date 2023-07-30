//
//  CoreDataManager.swift
//  CloneClassroomProject
//
//  Created by Consultant on 7/25/23.
//

import Foundation
import CoreData

class CoreDataManager: CoreDataOperationsProtocol{
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveDataToDatabase(itemList: [Item]) async throws {
        
        try await clearRecords()
        
        itemList.forEach { item in
            let itemEntity = ItemEntity(context: context)
            itemEntity.myId = item.id
            itemEntity.myTitle = item.title
            itemEntity.myBody = item.body
        }
        do{
            try context.save()
        }catch let error{
            print(error.localizedDescription)
            throw error
        }
    }
    
    func saveDataToDatabase(item: Item) async throws {
        let itemEntity = ItemEntity(context: context)
        itemEntity.myId = item.id
        itemEntity.myTitle = item.title
        itemEntity.myBody = item.body
        do{
            try context.save()
        }catch let error{
            print(error.localizedDescription)
            throw error
        }
    }
    
    
//    func deleteAllRecords() async throws {
//        do{
//            let list = try await getDataFromDatabase()
//            list.forEach { entity in
//                context.delete(entity)
//            }
//            try context.save()
//            print("All records deleted")
//        }catch let error{
//            print(error.localizedDescription)
//        }
//    }
    
    func getDataFromDatabase() async throws -> [ItemEntity] {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "", arguments: <#T##CVaListPointer#>)
        let result = try context.fetch(request)
        
        return result
    }
    
    func clearRecords() async throws{
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        let results = try context.fetch(request)
        results.forEach{ item in
            context.delete(item)
        }
        try context.save()
        print("All record were cleared")
    }
    
    
}
