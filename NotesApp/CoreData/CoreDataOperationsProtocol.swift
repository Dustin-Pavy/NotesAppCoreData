//
//  CoreDataOperationsProtocol.swift
//  CloneClassroomProject
//
//  Created by Consultant on 7/25/23.
//

import Foundation

protocol CoreDataOperationsProtocol{
    func saveDataToDatabase(itemList: [Item]) async throws
    func getDataFromDatabase() async throws -> [ItemEntity]
}
