//
//  FileCache.swift
//  ToDoList
//
//  Created by Powers Mikaela on 6/18/24.
//

import Foundation

class FileCache {
    private var toDoItems: [ToDoItem] = []
    private let filePath: String
    
    init(filepath: String) {
        self.filePath = filepath
        self.toDoItems = []
    }
    
    func addNewItem(_ toDoItem: ToDoItem) {
        guard !toDoItems.contains(where: { $0.id == toDoItem.id }) else { return }
        toDoItems.append(toDoItem)
    }
    
    func removeItem(withId id: String) {
        toDoItems.removeAll(where: { $0.id == id })
    }
    
    func saveItemsToJSON() {
        
        let JSONitems = toDoItems.map { $0.json }
        
        do {
            
            let JSONdata = try JSONSerialization.data(withJSONObject: JSONitems, options: .prettyPrinted)
            try JSONdata.write(to: URL(fileURLWithPath: filePath))
            
        } catch {
            
            print("Failed to save file: \(error)")
            
        }
        
    }
    
    func loadItemsFromJSON() {
        
        do {
            
            let JSONdata = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let JSONitems = try JSONSerialization.jsonObject(with: JSONdata, options: []) as? [Any] ?? []
            toDoItems = JSONitems.compactMap { ToDoItem.parse(json: $0) }
            
        } catch {
            
            print("Failed to load file: \(error)")
            
        }
        
    }
    
    func saveToCSV() {
        
        let CSVitems = toDoItems.map { $0.csv }
        
        do {
            
            let CSVdata = CSVitems.joined(separator: "\n").data(using: .utf8)!
            try CSVdata.write(to: URL(fileURLWithPath: filePath))
            
        } catch {
            
            print("Failed to save file: \(error)")
            
        }
        
    }
    
    func loadItemsFromCSV() {
        
        do {
            
            let CSVdata = try String(contentsOf: URL(fileURLWithPath: filePath))
            let CSVitems = CSVdata.components(separatedBy: "\n")
            toDoItems = CSVitems.compactMap { ToDoItem.parse(csv: $0) }
            
        } catch {
            
            print("File reading error: \(error)")
            
        }
        
    }
    
}

