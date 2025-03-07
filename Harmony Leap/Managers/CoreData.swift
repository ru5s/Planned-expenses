//
//  CoreData.swift
//  Harmony Leap
//
//  
//

import CoreData
import UIKit

class CoreDataService: ObservableObject {
    static let shared = CoreDataService()
    
    let container: NSPersistentCloudKitContainer = {
        return NSPersistentCloudKitContainer(name: "Harmony_Leap")
    }()
    
    init(inMemory: Bool = false) {
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores { storeDescription, err in
            if let err = err {
                fatalError(err.localizedDescription)
            }
        }
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access document directory")
        }
        let dbUrl = documentDirectory.appendingPathComponent("Harmony_Leap")
        print("Path to database: \(dbUrl.path)")
    }
    
    func save() throws {
        let context = container.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    
    func saveItem(category: String, loanAmount: Double, loanTerm: Double, interestRate: Double, loanBalancePlusPerc: Double, debt: Double) {
        let item = Item(context: container.viewContext)
        item.id = UUID()
        item.category = category
        item.loanAmount = loanAmount
        item.loanTerm = loanTerm
        item.interestRate = interestRate
        item.loanBalancePlusPercent = loanBalancePlusPerc
        item.debt = debt
        
        try? save()
    }
    
    func saveSubItem(item: Item, category: String, paymentAmount: Double, date: Date, debt: Double) {
        let subItem = SubItem(context: container.viewContext)
        subItem.subId = UUID()
        subItem.category = category
        subItem.paymantAmount = paymentAmount
        subItem.dateOfPayment = date
        item.debt = debt
        item.addToSubitem(subItem)
        
        try? save() //!!!!!
    }
    
    func removeItemFromCoreData(id: UUID) {
        if let findItem = searchItem(forUUID: id) {
            let context = container.viewContext
            context.delete(findItem)
            try? save()
        }
    }
    func removeSubItemFromCoreData(id: UUID) {
        if let findItem = searchSubItem(forUUID: id) {
            let context = container.viewContext
            context.delete(findItem)
            try? save()
        }
    }
    func searchItem (forUUID uuid: UUID) -> Item? {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            return nil
        }
    }
    func searchSubItem (forUUID uuid: UUID) -> SubItem? {
        let fetchRequest: NSFetchRequest<SubItem> = SubItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "subId == %@", uuid as CVarArg)
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            return nil
        }
    }
    func removeAll() {
        print("erase data from Investment")
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let subFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SubItem")
        let batchDeleteSubRequest = NSBatchDeleteRequest(fetchRequest: subFetchRequest)
        do {
            try container.viewContext.execute(batchDeleteRequest)
        } catch {
            print("Error deleting data: \(error.localizedDescription)")
        }
        do {
            try container.viewContext.execute(batchDeleteSubRequest)
        } catch {
            print("Error deleting data: \(error.localizedDescription)")
        }
    }
}
