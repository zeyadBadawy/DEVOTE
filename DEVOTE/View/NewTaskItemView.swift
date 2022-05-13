//
//  NewTaskItemView.swift
//  DEVOTE
//
//  Created by Zeyad Badawy on 11/05/2022.
//

import SwiftUI

struct NewTaskItemView: View {
    //MARK: PROPERTIES
    @State private var task:String = ""
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("isDarkMode") private var isDarkMode = false

    @Binding var isShowing:Bool
    private var isButtonDisabeled:Bool  {
        task.isEmpty
    }
    
    //MARK: Functions
    
    private func addItem() {
        hideKeyboard()
        isShowing = false 
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.id = UUID()
            newItem.completion = false
            do {
                try viewContext.save()
                task = ""
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    //MARK: BODY
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .center, spacing: 12) {
                TextField("New Task" , text: $task)
                    .padding()
                    .background(with: isDarkMode ? Color(UIColor.tertiarySystemBackground) :  Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .foregroundColor(.pink)
                    .font(.system(size: 24 , design: .rounded).weight(.bold))
                
                Button {
                    addItem()
                    playSound(sound: "sound-ding", type: "mp3")
                    feedback.notificationOccurred(.success)
                } label: {
                    Text("SAVE")
                        .font(.system(size: 24 , design: .rounded).weight(.bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(
                              minWidth: 0,
                              maxWidth: .infinity,
                              alignment: .center
                            )
                        .background(with: isButtonDisabeled ? UIColor.systemBlue.suColor : UIColor.systemPink.suColor)
                        .cornerRadius(16)
                }
                .disabled(isButtonDisabeled)
            }//: Vstack
            .padding()
            .background(with: isDarkMode ? UIColor.secondarySystemBackground.suColor : .white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.65), radius: 25)
            .frame(maxWidth:640)
        }//: VStack
        .padding()
    }
}
//MARK: PREVIEW
struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            NewTaskItemView(isShowing: .constant(true))
                .previewDevice("iPhone 12 Pro")
                .background {
                    Color.gray.ignoresSafeArea()
                }
        } else {
            // Fallback on earlier versions
        }
        
    }
}



