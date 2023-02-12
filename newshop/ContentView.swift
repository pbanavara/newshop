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
                    Text("Today's cart")
                        .font(.title)
                        .foregroundColor(Color.blue)
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
                Text(item.desc!).padding(.trailing, 150)
                Text(String(item.price))
            }
            Text("All year round").foregroundColor(Color.secondary)
        
    }
}

struct CartItemButtonRow : View {
    
    var body : some View {
        HStack {
            
            Button {
                
            }
            label: {
                Text("Add")
            }
            .foregroundColor(Color.gray).contentShape(Rectangle())
                .buttonStyle(.bordered)
            
            Button {
                
            }
            label: {
                Text("Delete")
            }
            .foregroundColor(Color.blue).contentShape(Rectangle())
                .buttonStyle(.bordered)
            
        }
    }
    
}
struct CheckoutButtons: View {
    
    var body : some View {
        HStack {
            Button {
                
            }
            label: {
                Text("Discard").padding(.top, 5).padding(.bottom, 5).padding(.leading, 10).padding(.trailing, 10)
            }
            .buttonStyle(.bordered)
            .padding(.trailing, 50)
            
            Button {
                
            }
            label: {
                Text("Checkout").padding(.top, 5).padding(.bottom, 5).padding(.leading, 10).padding(.trailing, 10)
            }
            .buttonStyle(.bordered)
            
            
        }
    }
    
    
}

struct Cart: View, Identifiable {
    var id = UUID()
    var item: Item
    var body : some View {
        VStack (alignment: .leading) {
            CartItem.init(item: item)
            CartItemButtonRow.init()
        }
        
    }
}

struct CartView : View, Identifiable {
    
    var id = UUID()
    @State var translation: CGSize = .zero
    var items: FetchedResults<Item>
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Text("Fruits").font(.title).foregroundColor(Color.blue)
                ForEach(items) { item in
                    Cart.init(item: item)
                }
                CheckoutButtons.init()
            }.frame(width: geometry.size.width * 0.95 , height: geometry.size.height * 0.8)
            
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .offset(x: self.translation.width, y: self.translation.height) // 2
            
        }
    }
    
}

struct cardStackView: View {
    var items: FetchedResults<Item>
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        
            let offset: CGFloat = CGFloat(items.count - 1 - id) * 10
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
        let _ = print("Cardwidth")
        let _ = print(self.items)

        VStack {
            GeometryReader { geometry in
                VStack(spacing: 20){
                    DateView().frame(width: geometry.size.width * 0.95).padding(.trailing)
                    ZStack
                    {
                        ForEach (items, id:\.self) { item in
                            CartView(items: items).frame(width: self.getCardWidth(geometry, id: Int(item.id)), height: geometry.size.height)
                                .offset(x: 0, y: self.getCardOffset(geometry, id: Int(item.id)))
    
                        }
                    }
                    
                }
            }
        }.padding(.leading)
            .padding(.top)
        
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.id, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    func loadData() {
        if items.count == 0 {
            struct ItemStr {
                var id: Int
                var desc: String
                var price: Float
                
            }
            let descriptions: [ItemStr] = [ ItemStr(id: 0, desc: "Banana", price: 100.0), ItemStr(id: 1, desc: "Orange", price: 20.0),
                                            ItemStr(id: 2, desc: "Mango", price: 500.0), ItemStr(id: 3, desc: "Melon", price: 100.0),
                                            ItemStr(id: 4, desc: "Grapes", price: 500.0)]
            descriptions.forEach { description in
                let newItem = Item(context: viewContext)
                newItem.timestamp = Date()
                newItem.id = Int16(description.id)
                newItem.desc = description.desc
                newItem.price = description.price
            }
        }
        do {
            try self.viewContext.save()
        } catch {
        }
    }
    

    var body: some View {
    
        TabView {
            cardStackView(items: items).onAppear(perform: loadData)
                .tabItem {
                    Image(systemName: "cart.fill")
                    
            }
            Text("Friends Screen")
                .tabItem {
                    Image(systemName: "person.2.fill")
                    
            }
            Text("Nearby Screen")
                .tabItem {
                    Image(systemName: "square.and.arrow.up")
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
