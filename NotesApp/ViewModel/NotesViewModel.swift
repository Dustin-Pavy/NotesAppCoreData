//
//  NotesViewModel.swift
//  NotesApp
//
//  Created by Consultant on 7/29/23.
//

import Foundation
import SwiftUI

@MainActor
class NotesViewModel: ObservableObject {
    
    @Published var itemList = [Item]()
    
    init(){}
    
    var context = PersistenceController.shared.container.newBackgroundContext()
    
    func getInfoFromDB() async{
        do{
            let coreDataManager: CoreDataManager = CoreDataManager(context: context)
            let results: [ItemEntity] = try await coreDataManager.getDataFromDatabase()
            
            results.forEach { data in
                let item = Item(from: data)
                itemList.append(item)
            }
            print(itemList)
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func addItemToDB(uuidString: String, title: String, body: String) async{
        let item = Item(id: uuidString, title: title, body: body)
        itemList.append(item)
        let coreDataManager: CoreDataManager = CoreDataManager(context: context)
        do{
            try await coreDataManager.saveDataToDatabase(item: item)
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func saveItemListToDB() async{
        let coreDataManager: CoreDataManager = CoreDataManager(context: context)
        do{
            try await coreDataManager.saveDataToDatabase(itemList: itemList)
        } catch let error{
            print(error.localizedDescription)
        }
    }
    
    func clearDatabase() async{
        let coreDataManager: CoreDataManager = CoreDataManager(context: context)
        do{
            try await coreDataManager.clearRecords()
        }catch let error{
            print(error.localizedDescription)
        }
        itemList = []
    }
    
}
