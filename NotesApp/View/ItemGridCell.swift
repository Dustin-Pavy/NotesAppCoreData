//
//  ItemGridCell.swift
//  NotesApp
//
//  Created by Consultant on 7/29/23.
//

import SwiftUI

struct ItemGridCell: View {
    
    var myTitle: String = "No Title"
    var myBody: String = "No Text"
    var myItem: Item = Item(id: "", title: "", body: "")
    
    var colorArray: [String] = ["fadda2", "6b61ff", "66a1ff", "8ecde6", "f0eff4"]
    @State var randColor: Int = 0
    @State var showDetails: Bool = false
    
    init(){}
    init(_ title: String, _ body: String, _ item: Item){
        self.myTitle = title
        self.myBody = body
        self.myItem = item
    }
    
    var body: some View {
        Button {
            showDetails = true
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black)
                Rectangle()
                    .foregroundColor(Color(hex: colorArray[randColor], alpha: 0.4))
                VStack(alignment: .center){
                    Text(myTitle)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                    Text(myBody)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    Spacer()
                }
            }
            .frame( height: 175)
            .onAppear(){
                self.randColor = Int.random(in: 0..<colorArray.count)
            }
        }
        .fullScreenCover(isPresented: $showDetails, content: {
            NoteDetailScreen(thisTitle: myTitle, thisBody: myBody, color: colorArray[randColor], isNew: false, thisItem: myItem)})
        .padding(2.0)
    }
}

struct ItemGridCell_Previews: PreviewProvider {
    static var previews: some View {
        ItemGridCell()
    }
}
