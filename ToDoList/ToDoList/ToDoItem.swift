//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Powers Mikaela on 6/18/24.
//

import Foundation

struct ToDoItem {
    
    var id: String
    var text: String
    var importance: Importance
    var deadline: Date?
    var isCompleted: Bool
    var creationDate: Date
    var modificationDate: Date?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date?,
        isCompleted: Bool,
        creationDate: Date,
        modificationDate: Date?
    ) {
        
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        
    }
    
}

extension ToDoItem {
    
    enum Constants {
        static let maxCount = 7
        static let minCount = 4
        static let defaultValueForImportance = Importance.usual
    }
        
    enum Importance: String {
        case unimportant
        case usual
        case important
    }
    
    enum CodingKeys {
        static let idKey: String = "id"
        static let textKey: String = "text"
        static let importanceKey: String = "importance"
        static let deadlineKey: String = "deadline"
        static let isCompletedKey: String = "isCompleted"
        static let creationDateKey: String = "creationDate"
        static let modificationDateKey: String = "modificationDate"
    }
    
}

extension ToDoItem {
    
    static func parse(json: Any) -> ToDoItem? {
        
        guard let dict = json as? [String: Any],
              let text = dict[CodingKeys.textKey] as? String,
              let isCompleted = dict[CodingKeys.isCompletedKey] as? Bool,
              let creationDate = dict[CodingKeys.creationDateKey] as? Date else {
            return nil
        }
        
        var importance: Importance
        
        if let stringForImportance = dict[CodingKeys.importanceKey] as? String {
            if let unwrappedImportance = Importance(rawValue: stringForImportance) {
                importance = unwrappedImportance
            } else {
                return nil
            }
        } else {
            importance = .usual
        }
        
        let id = dict[CodingKeys.idKey] as? String ?? UUID().uuidString
        let modificationDate = dict[CodingKeys.modificationDateKey] as? Date
        let deadline = dict[CodingKeys.deadlineKey] as? Date
        
        return ToDoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isCompleted: isCompleted,
            creationDate: creationDate,
            modificationDate: modificationDate
        )
        
    }
    
    var json: Any {
        
        var dict: [String: Any] = [
            CodingKeys.idKey: id,
            CodingKeys.textKey: text,
            CodingKeys.isCompletedKey: isCompleted,
            CodingKeys.creationDateKey: creationDate
        ]
        
        if importance != .usual {
            dict[CodingKeys.importanceKey] = importance
        }
        
        if let deadline = deadline {
            dict[CodingKeys.deadlineKey] = deadline
        }
        
        if let modificationDate = modificationDate {
            dict[CodingKeys.modificationDateKey] = modificationDate
        }
        
        return dict
        
    }
    
}

extension ToDoItem {
    
    static func parse(csv: String) -> ToDoItem? {
        let components = csv.components(separatedBy: ",")
        
        guard components.filter({$0 != ""}).count >= Constants.minCount,
              components.count <= Constants.maxCount,
              let creationDate = DateFormatter().date(from: components[3]) else { return nil }
        
        let id = components[0] == "" ? UUID().uuidString : components[0]
        let text = components[1]
        let isCompleted = Bool(components[2]) ?? false
        let importanceString = components[4] == "" ? Constants.defaultValueForImportance.rawValue : components[4]
        let importance = Importance(rawValue: importanceString)!
        let deadline: Date? = components[5] == "" ? nil : DateFormatter().date(from: components[5])
        let modficationDate: Date? = components[6] == "" ? nil : DateFormatter().date(from: components[6])
        
    
        
        return ToDoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isCompleted: isCompleted,
            creationDate: creationDate,
            modificationDate: modficationDate
        )
        
    }
    
    var csv: String {
        var string = ""
        
        string += "\(id),\(text),\(isCompleted),\(Int(creationDate.timeIntervalSince1970)),"
         
        if importance != .usual {
            string += "\(importance.rawValue),"
        } else {
            string += ","
        }
        
        if let deadline = deadline {
            string += "\(Int(deadline.timeIntervalSince1970)),"
        } else {
            string += ","
        }
        
        if let modificationDate = modificationDate {
            string += "\(Int(modificationDate.timeIntervalSince1970)),"
        } else {
            string += ","
        }
        
        return string
    }
}

