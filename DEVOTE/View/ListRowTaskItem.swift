//
//  ListRowTaskItem.swift
//  DEVOTE
//
//  Created by Zeyad Badawy on 11/05/2022.
//

import SwiftUI

struct ListRowTaskItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var item:Item
    
    var body: some View {
        Toggle(isOn: $item.completion) {
            Text(item.task ?? "" )
                .font(.system(.title2 , design: .rounded)).fontWeight(.heavy)
                .foregroundColor(item.completion ? Color.pink : Color.primary)
                .padding(.vertical , 12)
                .animation(.default)
        }//: Toggle
        .toggleStyle(CheckBoxStyle())
        .onReceive(item.objectWillChange) { _ in
            try? viewContext.save()
        }
    }
}
