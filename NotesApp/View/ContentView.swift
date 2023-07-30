//
//  ContentView.swift
//  NotesApp
//
//  Created by Consultant on 7/25/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @EnvironmentObject var notesVM: NotesViewModel
    
    @State var myItemList: [Item] = []
    @State var showAddView = false
    
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView{
            ScrollView{
                if(notesVM.itemList.count != 0){
                    LazyVGrid(columns: columns){
                        ForEach(Array(notesVM.itemList.enumerated()), id: \.element.id){ index, item in
                            ItemGridCell(item.title, item.body, item)
                                .overlay(
                                    DeleteButton( number: item, numbers: $myItemList, onDelete: removeRows)
                                    , alignment: .topTrailing
                                )
                        }
                    }
                }
                else{
                    Text("No Notes!")
                        .multilineTextAlignment(.center)
                    
                    
                }
                
            }
            .onChange(of: notesVM.itemList, perform: { newValue in
                myItemList = notesVM.itemList
            })
            .onAppear(){
                myItemList = notesVM.itemList
            }
            .task{
                await notesVM.getInfoFromDB()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear"){
                        Task{
                            await notesVM.clearDatabase()
                        }
                    }
                }
                ToolbarItem {
                    Button("+", action: {showAddView = true})
                        .fullScreenCover(isPresented: $showAddView, content: {NoteDetailScreen(isNew: true)})
//                    {
//                        Task{
//                            await notesVM.addItemToDB(uuidString: UUID().uuidString, title: "new", body: "some text")
//                        }
//                    }
                }
                ToolbarItem {
                    EditButton()
                }
                ToolbarItem (placement: .principal){
                    Text("Notes")
                        .font(.largeTitle)
                        .italic()
                        .bold()
                }
            }
        }
        .padding()
    }
    
    func removeRows(at offsets: IndexSet) {
        withAnimation {
            notesVM.itemList.remove(atOffsets: offsets)
        }
        Task{
            await notesVM.saveItemListToDB()
        }
    }
    
    func getSqlLitePath(){
        
            guard let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            else{
                return
            }
            let sqlLitePath = url.appendingPathComponent("CloneClassroomProject")
            print(sqlLitePath)
    }
}

struct DeleteButton<T>: View where T: Equatable {
  @Environment(\.editMode) var editMode

  let number: T
  @Binding var numbers: [T]
  let onDelete: (IndexSet) -> ()

  var body: some View {
    VStack {
        if self.editMode?.wrappedValue == .active {
            Button(action: {
                if let index = numbers.firstIndex(of: number) {
                    self.onDelete(IndexSet(integer: index))
                }
            }) {
                Image(systemName: "minus.circle")
            }
            .offset(x: -2, y: 2)
        }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NotesViewModel())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
