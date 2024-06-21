import Foundation

class FileCache {
    private var toDoItems: [String: ToDoItem] = [:]
    private let fileForSaving: String
    
    init(fileForSaving: String) {
        self.fileForSaving = fileForSaving
        self.toDoItems = [:]
    }
    
    func addNewItem(_ toDoItem: ToDoItem) {
        if let item = toDoItems[toDoItem.id] {
        } else {
            toDoItems[toDoItem.id] = toDoItem
        }
    }
    
    func removeItem(withId id: String) {
        toDoItems[id] = nil
    }
    
    func saveItemsToJSON() {
        do {
            guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            
            let JSONitems = toDoItems.values.map { $0.json }
            let filePath = directory.appending(path: "\(fileForSaving).json")
            let JSONdata = try JSONSerialization.data(withJSONObject: JSONitems, options: .prettyPrinted)
            try JSONdata.write(to: filePath)
            
        } catch {
            print("Failed to save file: \(error)")
        }
    }
    
    func loadItemsFromJSON() {
        do {
            guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

            let filePath = directory.appending(path: "\(fileForSaving).json")
            let JSONdata = try Data(contentsOf: filePath)
            let JSONitems = try JSONSerialization.jsonObject(with: JSONdata, options: []) as? [Any] ?? []
            let parsedItems = JSONitems.compactMap { ToDoItem.parse(json: $0) }
            toDoItems = Dictionary(uniqueKeysWithValues: zip(parsedItems.map { $0.id }, parsedItems.map { $0 }))
            
        } catch {
            print("Failed to load file: \(error)")
        }
    }
    
    func saveToCSV() {
        do {
            guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

            let CSVitems = toDoItems.values.map { $0.csv }
            let filePath = directory.appending(path: "\(fileForSaving).csv")
            let CSVdata = CSVitems.joined(separator: "\n").data(using: .utf8)!
            try CSVdata.write(to: filePath, options: .atomic)
            
        } catch {
            print("Failed to save file: \(error)")
        }
    }
    
    func loadItemsFromCSV() {
        do {
            guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

            let filePath = directory.appending(path: "\(fileForSaving).csv")
            let CSVdata = try String(contentsOf: filePath)
            let CSVitems = CSVdata.components(separatedBy: "\n")
            let parsedItems = CSVitems.compactMap { ToDoItem.parse(csv: $0) }
            toDoItems = Dictionary(uniqueKeysWithValues: zip(parsedItems.map { $0.id }, parsedItems.map { $0 }))
            
        } catch {
            print("File reading error: \(error)")
        }
    }
}
