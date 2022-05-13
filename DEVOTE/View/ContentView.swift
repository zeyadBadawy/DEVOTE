//
//  ContentView.swift
//  DEVOTE
//
//  Created by Zeyad Badawy on 09/05/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //MARK: PROPERTIES
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var task:String = ""
    @State private var showAddItem:Bool = false
    private var isButtonDisabeled:Bool  {
        task.isEmpty
    }
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    //MARK: FUNC
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    //MARK: BODY
    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient.ignoresSafeArea()
                BGImageView()
                    .frame(
                          minWidth: 0,
                          maxWidth: .infinity,
                          minHeight: 0,
                          maxHeight: .infinity,
                          alignment: .topLeading
                        )
                    
                VStack {
                    //MARK: HEADER
                    
                    HStack(spacing:10) {
                        //TITLE
                        Text("DEVOTE")
                            .font(.system(.largeTitle, design: .rounded).weight(.heavy))
                            .padding(.leading , 16)
                            .foregroundColor(.white)
                            Spacer()
                        
                        //EDIT
                        
                        ZStack {
                            Capsule().stroke(Color.white , lineWidth: 2)
                                .frame(width: 70, height: 24, alignment: .center)
                            EditButton()
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal , 10)
                        
                        //APPEARNCE
                        
                        Button {
                            // here toggle apperance
                            isDarkMode.toggle()
                            playSound(sound:"sound-tap", type: "mp3")
                            feedback.notificationOccurred(.success)

                        } label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24, height: 24, alignment: .center)
                                .foregroundColor(.white)
                                .font(.system(.title , design: .rounded))
                                .padding(.trailing , 16)
                        }

                        
                    }//: HStack
                    
                    Spacer(minLength: 80)
                    
                    //MARK: ADD NEW ITEM
                    Button {
                        showAddItem = true
                        playSound(sound:"sound-ding", type: "mp3")
                        feedback.notificationOccurred(.success)
                    } label: {
                        ZStack {
                            LinearGradient(colors: [Color.pink , Color.blue], startPoint: .leading, endPoint: .trailing)
                                .clipShape(Capsule())
                                .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 0.4)
                            HStack {
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 24 , design: .rounded).weight(.bold))
                                Text("New Task")
                                    .font(.system(size: 24 , design: .rounded).weight(.bold))
                            }
                            .foregroundColor(.white)
                        }
                    }
                    .frame(width: 200, height: 60, alignment: .center)

                    List {
                        ForEach(items) { item in
                            NavigationLink {
                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                            } label: {
                                VStack(alignment:.leading) {
                                    
                                    ListRowTaskItem(item: item)
                                        
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }//: List
                    .listStyle(InsetGroupedListStyle())
                    .shadow(color: .black.opacity(0.3), radius: 12)
                    .padding(.vertical , 0)
                    .frame(maxWidth:640)
                    
                }//: Vstack
                .blur(radius:showAddItem ? 0.8 : 0 , opaque: false)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.4))
                
                //MARK: Show item view
                if showAddItem {
                    BlankView(
                        backgroundColor: isDarkMode ? .black : .gray,
                        backgroundOpacity: isDarkMode ? 0.3 : 0.5
                    )
                        .onTapGesture {
                            showAddItem = false
                        }
                    NewTaskItemView(isShowing: $showAddItem)
                }
            }//: ZStack
            .onAppear(perform: {
                UITableView.appearance().backgroundColor = .clear
            })
            .navigationBarHidden(true)
        }//: Navigation
    }
}
//MARK: PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
