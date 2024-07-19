//
//  JSONparsing.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 18.07.2024.
//

import Foundation

extension FileCache {
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
}
