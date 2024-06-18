//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Powers Mikaela on 6/18/24.
//

import Foundation

enum Importance: String {
    case Unimportant
    case Usual
    case Important
}

struct ToDoItem {
    
    var id: String
    var text: String
    var importance: Importance
    var deadline: Date?
    var isCompleted: Bool
    var creationDate: Date
    var modificationDate: Date?
    
    init(id: String = UUID().uuidString, text: String, importance: Importance, deadline: Date?, isCompleted: Bool, creationDate: Date, modificationDate: Date?) {
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
    
    static func parse(json: Any) -> ToDoItem? {
        
        guard let dict = json as? [String: Any],
              let text = dict["text"] as? String,
              let isCompleted = dict["isCompleted"] as? Bool,
              let creationDate = dict["creationDate"] as? Date else {
            return nil
        }
        
        let id = dict["id"] as? String ?? UUID().uuidString
        let importance = dict["importance"] as? Importance ?? .Usual
        let modificationDate = dict["modificationDate"] as? Date
        let deadline = dict["deadline"] as? Date
        
        return ToDoItem(id: id, text: text, importance: importance, deadline: deadline, isCompleted: isCompleted, creationDate: creationDate, modificationDate: modificationDate)
        
    }
    
    var json: Any {
        
        var dict: [String: Any] = [
            "id": id,
            "text": text,
            "isDone": isCompleted,
            "creationDate": creationDate
        ]
        
        if importance != .Usual {
            dict["importance"] = importance
        }
        
        if let deadline = deadline {
            dict["deadline"] = deadline
        }
        
        if let modificationDate = modificationDate {
            dict["modificationDate"] = modificationDate
        }
        
        return dict
        
    }
    
}

extension ToDoItem {
    
    static func parse(csv: String) -> ToDoItem? {
        let components = csv.components(separatedBy: ",")
        
        guard components.filter({$0 != ""}).count >= 4, components.count <= 7 else { return nil }
        
        let id = components[0] == "" ? UUID().uuidString : components[0]
        let text = components[1]
        let isCompleted = Bool(components[2]) ?? false
        let creationDate: Date = DateFormatter().date(from: components[3])!
        let importanceString = components[4] == "" ? "Usual" : components[4]
        let importance = Importance(rawValue: importanceString)!
        let deadline: Date? = components[5] == "" ? nil : DateFormatter().date(from: components[5])
        let modficationDate: Date? = components[6] == "" ? nil : DateFormatter().date(from: components[6])
        
        return ToDoItem(id: id, text: text, importance: importance, deadline: deadline, isCompleted: isCompleted, creationDate: creationDate, modificationDate: modficationDate)
        
    }
    
    var csv: String {
        var string = ""
        
        string += "\(id),\(text),\(isCompleted),\(Int(creationDate.timeIntervalSince1970)),"
        
        if importance != .Usual {
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

