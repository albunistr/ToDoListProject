import Foundation

struct TodoItem {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isCompleted: Bool
    let createdAt: Date
    let changedAt: Date?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date? = nil,
        isCompleted: Bool,
        createdAt: Date = Date(),
        changedAt: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.changedAt = changedAt
    }
}
// MARK: Constants for TodoItem
extension TodoItem {
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
        static let createdAtKey: String = "createdAt"
        static let changedAtKey: String = "changedAt"
    }
}
// MARK: JSON researching
extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        guard let dict = json as? [String: Any],
              let text = dict[CodingKeys.textKey] as? String,
              let isCompleted = dict[CodingKeys.isCompletedKey] as? Bool,
              let createdAt = dict[CodingKeys.createdAtKey] as? Date
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
        let changedAt = dict[CodingKeys.changedAtKey] as? Date
        let deadline = dict[CodingKeys.deadlineKey] as? Date
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isCompleted: isCompleted,
            createdAt: createdAt,
            changedAt: changedAt
        )
    }
    
    var json: Any {
        var dict: [String: Any] = [
            CodingKeys.idKey: id,
            CodingKeys.textKey: text,
            CodingKeys.isCompletedKey: isCompleted,
            CodingKeys.createdAtKey: createdAt
        ]
        
        if importance != .usual {
            dict[CodingKeys.importanceKey] = importance
        }
        
        if let deadline = deadline {
            dict[CodingKeys.deadlineKey] = deadline
        }
        
        if let changedAt = changedAt {
            dict[CodingKeys.changedAtKey] = changedAt
        }
        
        return dict
    }
}
// MARK: CSV researching
extension TodoItem {
    static func parse(csv: String, separator: Character) -> TodoItem? {
        var components = [String]()
        var currentComponent = ""
        var insideQuotos = false
        
        for char in csv {
            if char == "\"" {
                insideQuotos.toggle()
            } else if char == separator, !insideQuotos {
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
              let createdAtDouble = Double(components[3])
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
        let createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtDouble))
        let deadlineDouble = Double(components[5]) ?? nil
        let deadline = deadlineDouble != nil ? Date(timeIntervalSince1970: TimeInterval(deadlineDouble!)) : nil
        let changedAtDouble = Double(components[6]) ?? nil
        let changedAt = changedAtDouble != nil ? Date(timeIntervalSince1970: TimeInterval(changedAtDouble!)) : nil
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isCompleted: isCompleted,
            createdAt: createdAt,
            changedAt: changedAt
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
        let changedAtString = changedAt.flatMap { String($0.timeIntervalSince1970) } ?? ""
        
        let textWithQuotos = "\"\(text)\""
        
        let elements = [
            id,
            textWithQuotos,
            String(isCompleted),
            String(createdAt.timeIntervalSince1970),
            importanceString,
            deadlineString,
            changedAtString
        ]
        
        return elements.joined(separator: ",")
    }
}
