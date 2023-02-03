//
//  ContentView.swift
//  newshop
//
//  Created by Pradeep Banavara on 02/02/23.
//

import SwiftUI
import CoreData


struct DateView: View {
    var body: some View {
      // Container to add background and corner radius to
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Friday, 10th January")
                        .font(.title)
                    Text("Today")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }.padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct CartItem : View {
    var item: Item
    var body : some View {
        HStack {
            Image(systemName: "heart.circle")
            Text(item.desc!).padding(.trailing, 100)
            Text(String(item.price))
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
    var item: Item
    var body : some View {
        VStack (alignment: .leading) {
            CartItem.init(item: item)
            CartItemButtonRow.init()
        }
        
    }
}

struct CartView : View {
    @Environment(\.managedObjectContext) var viewContext

    @State var translation: CGSize = .zero
    var items: FetchedResults<Item>
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ForEach(items) { item in
                    Cart.init(item: item)
                }
                .onDelete(perform: deleteItems)
                CheckoutButtons.init()
            }.frame(width: geometry.size.width * 0.95 , height: geometry.size.height * 0.8)
            
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .offset(x: self.translation.width, y: self.translation.height) // 2
            
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


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
            let offset: CGFloat = CGFloat(items.count - 1 - id) * 10
        print(geometry.size.width - offset)
            return geometry.size.width - offset
        }
        
        // 3
        /// Return the CardViews frame offset for the given offset in the array
        /// - Parameters:
        ///   - geometry: The geometry proxy of the parent
        ///   - id: The ID of the current user
        private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
            return  CGFloat(items.count - 1 - id) * 10
        }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    DateView().frame(width: geometry.size.width * 0.95).padding(.trailing)
                    ZStack
                    {
                        ForEach (self.items, id: \.self) { item in
                            CartView(items: items)
                                .frame(width: self.getCardWidth(geometry, id: Int(item.id)), height: geometry.size.height)
                                .offset(x: 0, y: self.getCardOffset(geometry, id: Int(item.id)))
                        }
                    }
                    Spacer()
                }
            }
        }.padding(.leading)
            .padding(.top)
        
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
