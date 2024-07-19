//
//  CSVpasing.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 18.07.2024.
//

import Foundation

extension FileCache {
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
}
