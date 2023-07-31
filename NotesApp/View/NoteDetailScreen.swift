//
//  NoteDetailScreen.swift
//  NotesApp
//
//  Created by Consultant on 7/29/23.
//

import SwiftUI

struct NoteDetailScreen: View {
    @EnvironmentObject var notesVM: NotesViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.scrollDismissesKeyboardMode) var scrollDismissesKeyboardMode

    
    @State var thisTitle: String = "Enter the Title"
    @State var thisBody: String = "Enter the body of the Note"
    @State var color: String = "aaaaaa"
    @State var isNew:Bool
    @State var thisItem: Item = Item(id: "", title: "", body: "")
    
    @FocusState var isInputActive: Bool
    
    var body: some View {
        ZStack(alignment: .center){
//            RoundedRectangle(cornerRadius: 20)
            Rectangle()
                .foregroundColor(Color(hex: color, alpha: 0.4))
                .ignoresSafeArea()
            VStack{
                TextField("Enter the Title",text: $thisTitle)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                isInputActive = false
                            }
                        }
                    }
                TextEditor(text: $thisBody)
//                    .scrollContentBackground(.hidden)
                //                    .background(.clear)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                    .cornerRadius(20)
                
                    .focused($isInputActive)
                
                    .scrollDismissesKeyboard(.immediately)
                
                WideButton(text: "Submit") {
                    if(isNew){
                        Task{
                            await notesVM.addItemToDB(uuidString: UUID().uuidString, title: thisTitle, body: thisBody)
                        }
                    }
                    else{
                        Task{
                            let index = notesVM.itemList.firstIndex{thisItem.id == $0.id}
                            notesVM.itemList[index!].body = thisBody
                            notesVM.itemList[index!].title = thisTitle
                            await notesVM.saveItemListToDB()
                        }
                    }
                    dismiss()
                }
                WideButton(text: "Cancel", color: Color(hex: "ff0040", alpha: 1)) {
                    dismiss()
                    //                    scrollDismissesKeyboardMode = .immediately
                }
                
                // Spacer()
            }
            .padding()
            
        }
        
        .ignoresSafeArea(.keyboard, edges: .vertical)
    }
}

struct NoteDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetailScreen(isNew: true)
    }
}
