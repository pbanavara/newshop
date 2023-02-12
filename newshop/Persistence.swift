//
//  Persistence.swift
//  newshop
//
//  Created by Pradeep Banavara on 02/02/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    
    let descriptions: [ItemStr] = [ ItemStr(id: 0, desc: "Banana", price: 100.0), ItemStr(id: 1, desc: "Orange", price: 20.0),
                                    ItemStr(id: 2, desc: "Mango", price: 500.0), ItemStr(id: 3, desc: "Melon", price: 100.0),
                                    ItemStr(id: 4, desc: "Grapes", price: 500.0)]
    
    func initialize_descr() {
        descriptions.forEach { description in
            let newItem = Item()
            newItem.timestamp = Date()
            newItem.id = Int16(description.id)
            newItem.desc = description.desc
            newItem.price = description.price
        }
    }
    
    struct ItemStr {
        var id: Int
        var desc: String
        var price: Float
        
    }

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "newshop")
        if inMemory {
            initialize_descr()
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print(storeDescription.description)
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
            }
        }
    }
}
