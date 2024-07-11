import Combine
import Foundation

protocol FileCacheProtocol {

    var toDoItems: [TodoItem] { get }

    func addNewOrUpdateItem(_ toDoItem: TodoItem)
    func removeItem(withId id: String)
    func saveItemsToJSON(fileForSaving: String)
    func loadItemsFromJSON(fileForSaving: String)
    func saveToCSV(fileForSaving: String)
    func loadItemsFromCSV(fileForSaving: String)
}

final class FileCache: FileCacheProtocol {
    private(set) var toDoItems: [TodoItem] = []

    func addNewOrUpdateItem(_ toDoItem: TodoItem) {
        if let index = toDoItems.firstIndex(where: { $0.id == toDoItem.id }) {
            toDoItems[index] = toDoItem
        } else {
            toDoItems.append(toDoItem)
        }
    }

    func removeItem(withId id: String) {
        toDoItems.removeAll(where: { $0.id == id })
    }

    func getItems() -> [TodoItem] {
        return toDoItems
    }

    func saveItemsToJSON(fileForSaving: String) {
        do {
            guard let filePath = generatingFilePath(file: fileForSaving, fileType: "json") else { return }

            let JSONitems = toDoItems.map { $0.json }
            let JSONdata = try JSONSerialization.data(withJSONObject: JSONitems, options: .prettyPrinted)
            try JSONdata.write(to: filePath)

        } catch {
            print("Failed to save file: \(error)")
        }
    }

    func loadItemsFromJSON(fileForSaving: String) {
        do {
            guard let filePath = generatingFilePath(file: fileForSaving, fileType: "json") else { return }

            let JSONdata = try Data(contentsOf: filePath)
            let JSONitems = try JSONSerialization.jsonObject(with: JSONdata, options: []) as? [Any] ?? []
            let parsedItems = JSONitems.compactMap { TodoItem.parse(json: $0) }

            for item in parsedItems {
                addNewOrUpdateItem(item)
            }

        } catch {
            print("Failed to load file: \(error)")
        }
    }

    func saveToCSV(fileForSaving: String) {
        do {
            guard let filePath = generatingFilePath(file: fileForSaving, fileType: "csv") else { return }

            let CSVitems = toDoItems.map { $0.csv }
            let CSVdata = CSVitems.joined(separator: "\n").data(using: .utf8)!
            try CSVdata.write(to: filePath, options: .atomic)

        } catch {
            print("Failed to save file: \(error)")
        }
    }

    func loadItemsFromCSV(fileForSaving: String) {
        do {
            guard let filePath = generatingFilePath(file: fileForSaving, fileType: "csv") else { return }

            let CSVdata = try String(contentsOf: filePath)
            let CSVitems = CSVdata.components(separatedBy: "\n")
            let parsedItems = CSVitems.compactMap { TodoItem.parse(csv: $0, separator: ",") }

            for item in parsedItems {
                addNewOrUpdateItem(item)
            }

        } catch {
            print("File reading error: \(error)")
        }
    }

    private func generatingFilePath(file: String, fileType: String) -> URL? {
        guard let directory = FileManager.default.urls(for: .documentDirectory,
                                                       in: .userDomainMask).first else { return nil }
        let filePath = directory.appending(path: "\(file).\(fileType)")
        return filePath
    }
}
