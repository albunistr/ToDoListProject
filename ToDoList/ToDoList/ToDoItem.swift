import Foundation

struct ToDoItem {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isCompleted: Bool
    let creationDate: Date
    let modificationDate: Date?
    
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
              let creationDate = dict[CodingKeys.creationDateKey] as? Date
        else {
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
        var components = [String]()
        var currentComponent = ""
        var insideQuotos = false
        
        for char in csv {
            if char == "\"" {
                insideQuotos.toggle()
            } else if char == ",", !insideQuotos {
                components.append(currentComponent)
                currentComponent = ""
            } else {
                currentComponent.append(char)
            }
        }
        
        components.append(currentComponent)
        
        guard components.count >= Constants.minCount,
              components.count <= Constants.maxCount,
              components[1] != "",
              let isCompleted = Bool(components[2]),
              let creationDateDouble = Double(components[3])
        else { return nil }
        
        var importance: Importance
        let importanceString = components[4]
        switch importanceString {
        case "":
            importance = Constants.defaultValueForImportance
        case Importance.unimportant.rawValue, Importance.important.rawValue:
            importance = Importance(rawValue: importanceString)!
        default:
            return nil
        }
        
        let id = components[0] == "" ? UUID().uuidString : components[0]
        let text = components[1]
        let creationDate = Date(timeIntervalSince1970: TimeInterval(creationDateDouble))
        let deadlineDouble = Double(components[5]) ?? nil
        let deadline = deadlineDouble != nil ? Date(timeIntervalSince1970: TimeInterval(deadlineDouble!)) : nil
        let modoficationDateDouble = Double(components[6]) ?? nil
        let modficationDate = modoficationDateDouble != nil ? Date(timeIntervalSince1970: TimeInterval(modoficationDateDouble!)) : nil
        
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
        var importanceString: String
        switch importance {
        case .usual:
            importanceString = ""
        case .important, .unimportant:
            importanceString = "\(importance.rawValue)"
        }
        
        let deadlineString = deadline.flatMap { String($0.timeIntervalSince1970) } ?? ""
        let modificationString = modificationDate.flatMap { String($0.timeIntervalSince1970) } ?? ""
        
        let textWithQuotos = "\"\(text)\""
        
        let elements = [
            id,
            textWithQuotos,
            String(isCompleted),
            String(creationDate.timeIntervalSince1970),
            importanceString,
            deadlineString,
            modificationString
        ]
        
        return elements.joined(separator: ",")
    }
}
