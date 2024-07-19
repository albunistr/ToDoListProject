//
//  TodoItem.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 27.06.2024.
//

import Foundation
import CocoaLumberjackSwift

// MARK: - Common methods

extension TodoItem {
    static func defaultItem(id: String = UUID().uuidString) -> TodoItem {
        TodoItem(id: id, text: "Что надо сделать?", importance: .usual)
    }

    func copy(
        id: String? = nil,
        text: String? = nil,
        importance: Importance? = nil,
        deadline: Date? = nil,
        isCompleted: Bool? = nil,
        createdAt: Date? = nil,
        changedAt: Date? = nil,
        color: String? = nil,
        category: Category? = nil
    ) -> Self {
        .init(
            id: id ?? self.id,
            text: text ?? self.text,
            importance: importance ?? self.importance,
            deadline: deadline ?? self.deadline,
            isCompleted: isCompleted ?? self.isCompleted,
            createdAt: createdAt ?? self.createdAt,
            changedAt: changedAt ?? self.changedAt,
            color: color ?? self.color,
            category: category ?? self.category
        )
    }
}

// MARK: - Constants for TodoItem

extension TodoItem {
    enum Category: String {
        case work
        case studying
        case hobby
        case other

        init(rawValue: Int) {
            switch rawValue {
            case 0:
                self = .work
            case 1:
                self = .studying
            case 2:
                self = .hobby
            default:
                self = .other
            }
        }

        func getOption(category: Category) -> Int {
            switch category {
            case .work:
                return 0
            case .studying:
                return 1
            case .hobby:
                return 2
            case .other:
                return 3
            }
        }
    }
}

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

        init(rawValue: Int) {
            switch rawValue {
            case 0:
                self = .unimportant
            case 1:
                self = .usual
            case 2:
                self = .important
            default:
                self = .usual
            }
        }

        func getOption(importance: Importance) -> Int {
            switch importance {
            case .unimportant:
                return 0
            case .usual:
                return 1
            case .important:
                return 2
            }
        }
        
        static func fromNetworkValueToImportance(importance: Importance) -> String? {
            switch importance {
            case .unimportant:
                return "low"
            case .usual:
                return "basic"
            case .important:
                return "important"
            }
        }
        
        static func fromImportanceToNetworkValue(importance: String) -> Importance? {
            switch importance {
            case "low":
                return .unimportant
            case "basic":
                return .usual
            case "important":
                return .important
            default:
                return nil
            }
        }
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

// MARK: - JSON researching

extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        guard let dict = json as? [String: Any],
              let text = dict[CodingKeys.textKey] as? String,
              let isCompleted = dict[CodingKeys.isCompletedKey] as? Bool,
              let createdAt = dict[CodingKeys.createdAtKey] as? Date,
              let id = dict[CodingKeys.idKey] as? String
        else {
            DDLogError("Invalid json")
            return nil
        }

        let importance: Importance
        let deadline: Date?
        let changedAt: Date?

        if let stringForImportance = dict[CodingKeys.importanceKey] as? String {
            if let unwrappedImportance = Importance(rawValue: stringForImportance) {
                importance = unwrappedImportance
            } else {
                return nil
            }
        } else {
            importance = .usual
        }

        deadline = (dict[CodingKeys.deadlineKey] as? Double).flatMap {
            Date(timeIntervalSince1970: TimeInterval($0))
        }

        changedAt = (dict[CodingKeys.changedAtKey] as? Double).flatMap {
            Date(timeIntervalSince1970: TimeInterval($0))
        }
        DDLogVerbose("JSON parsed success")
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
            CodingKeys.createdAtKey: createdAt.timeIntervalSince1970
        ]

        if importance != .usual {
            dict[CodingKeys.importanceKey] = importance.rawValue
        }

        if let deadline = deadline {
            dict[CodingKeys.deadlineKey] = deadline.timeIntervalSince1970
        }

        if let changedAt = changedAt {
            dict[CodingKeys.changedAtKey] = changedAt.timeIntervalSince1970
        }
        DDLogVerbose("JSON made success")
        return dict
    }
}

// MARK: - CSV researching

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
        else { 
            DDLogError("Invalid csv")
            return nil }

        var importance: Importance
        let importanceString = components[4]
        switch importanceString {
        case "":
            importance = Constants.defaultValueForImportance
        case Importance.unimportant.rawValue, Importance.important.rawValue:
            importance = Importance(rawValue: importanceString)!
        default:
            DDLogError("Invalid importance")
            return nil
        }

        let id = components[0] == "" ? UUID().uuidString : components[0]
        let text = components[1]
        let createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtDouble))
        let deadlineDouble = Double(components[5]) ?? nil
        let deadline = deadlineDouble != nil ? Date(timeIntervalSince1970: TimeInterval(deadlineDouble!)) : nil
        let changedAtDouble = Double(components[6]) ?? nil
        let changedAt = changedAtDouble != nil ? Date(timeIntervalSince1970: TimeInterval(changedAtDouble!)) : nil
        
        DDLogVerbose("CSV parsed success")
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
        DDLogVerbose("CSV made success")
        return elements.joined(separator: ",")
    }
}
