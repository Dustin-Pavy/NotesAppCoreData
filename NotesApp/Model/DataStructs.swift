//
//  DataStructs.swift
//  NotesApp
//
//  Created by Consultant on 7/28/23.
//

import Foundation

struct Item: Decodable, Identifiable, Equatable{
    var id: String
    var title: String
    var body: String
    
    init(id: String, title: String, body: String){
        self.id = id
        self.title = title
        self.body = body
        
    }
    
    init(from itemEntity: ItemEntity){
        self.id = itemEntity.myId ?? ""
        self.title = itemEntity.myTitle ?? ""
        self.body = itemEntity.myBody ?? ""
    }
}
