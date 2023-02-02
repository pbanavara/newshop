//
//  ContentView.swift
//  newshop
//
//  Created by Pradeep Banavara on 02/02/23.
//

import SwiftUI
import CoreData

struct CartItem : View {
    var body : some View {
        HStack {
            Image(systemName: "heart.circle")
            Text("Fresh Banana").padding(.trailing, 100)
            Text("$100")
        }
        Text("All year round").foregroundColor(Color.secondary)
    }
}

struct CartItemButtonRow : View {
    @Environment(\.managedObjectContext) private var viewContext
    var body : some View {
        HStack {
            Button(action: addItem) {
                Image(systemName
                      
                      : "plus")
            }.buttonStyle(.bordered)
            
            Button {
                
            }
            label: {
                Text("Delete")
            }
            .foregroundColor(Color.blue).contentShape(Rectangle())
                .buttonStyle(.bordered)
            
        }
    }
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
struct CheckoutButtons: View {
    
    var body : some View {
        HStack {
            Button {
                
            }
            label: {
                Text("Discard").padding(.top, 5).padding(.bottom, 5).padding(.leading, 20).padding(.trailing, 20)
            }
            .buttonStyle(.bordered)
            
            Button {
                
            }
            label: {
                Text("Checkout").padding(.top, 5).padding(.bottom, 5).padding(.leading, 20).padding(.trailing, 20)
            }
            .buttonStyle(.bordered)
            
            
        }
    }
    
    
}

struct Cart: View {
    var body : some View {
        VStack (alignment: .leading) {
            CartItem.init()
            CartItemButtonRow.init()
        }
        
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        HStack {
            NavigationView {
                List {
                    ForEach(items) { item in
                        Cart.init()
                    }
                    .onDelete(perform: deleteItems)
                    CheckoutButtons.init()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }
            
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
