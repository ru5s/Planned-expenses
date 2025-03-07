//
//  HomeVIewModel.swift
//  Harmony Leap
//
//  
//

import Foundation
import CoreData

class HomeVIewModel: ObservableObject {
    @Published var entrys: [Item] = []
    @Published var choosedItem: Item?
    @Published var currencyPair: [CurrencyModel] = [
        .init(id: 0, first: "USD", second: "EUR", fullName: "Euro", approximateСoefficient: 0.92, icon: "€"),
        .init(id: 1, first: "USD", second: "CHF", fullName: "Swiss franc", approximateСoefficient: 0.9, icon: "₣"),
        .init(id: 2, first: "USD", second: "GBP", fullName: "Pound sterling", approximateСoefficient: 0.79, icon: "£"),
        .init(id: 3, first: "USD", second: "JPY", fullName: "Japanese yen", approximateСoefficient: 151.76, icon: "¥"),
        .init(id: 4, first: "USD", second: "KZT", fullName: "Kazakhstani tenge", approximateСoefficient: 446.76, icon: "₸"),
        .init(id: 5, first: "USD", second: "THB", fullName: "Thai baht", approximateСoefficient: 36.35, icon: "฿"),
        .init(id: 6, first: "USD", second: "TRY", fullName: "Turkish lira", approximateСoefficient: 32.24, icon: "₺"),
    ]
    func getEntrys() {
        let fetchRequest: NSFetchRequest <Item> = Item.fetchRequest()
        do {
            let fetchItems = try  CoreDataService.shared.container.viewContext.fetch(fetchRequest)
            entrys = fetchItems
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    func removeSubItemFromItem(subItem: SubItem) {
        for item in entrys {
            if let superItem = item.subitem as? Set<SubItem>, superItem.contains(subItem) {
                item.removeFromSubitem(subItem)
            }
        }
    }
}
