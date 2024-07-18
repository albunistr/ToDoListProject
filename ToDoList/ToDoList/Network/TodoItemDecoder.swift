//
//  TodoItemDecoder.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 18.07.2024.
//

import Foundation

struct TodoItemDecoder: Codable {
    var id: String
    var text: String
    var importance: String
    var deadline: Int?
    var isCompleted: Bool
    var createdAt: Int
    var changedAt: Int
    var color: String
    var lastUpdatedBy: String
    
    init
    (
        todoItem: TodoItem
    )
    {
        self.id = todoItem.id
        self.text = todoItem.text
        self.importance = TodoItem.Importance.fromNetworkValueToImportance(importance: todoItem.importance)!
        self.deadline = todoItem.deadline != nil ? Int(todoItem.deadline!.timeIntervalSince1970) : nil
        self.isCompleted = todoItem.isCompleted
        self.createdAt = Int(todoItem.createdAt.timeIntervalSince1970)
        self.changedAt = todoItem.changedAt != nil ? Int(todoItem.changedAt!.timeIntervalSince1970) : Int(Date().timeIntervalSince1970)
        self.color = todoItem.color
        self.lastUpdatedBy = "default"
    }
    
    init
    (
        from decoder: Decoder
    )
    throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id  = try container.decode(String.self, forKey: .id)
        self.text = try container.decode(String.self, forKey: .text)
        self.importance = try container.decode(String.self, forKey: .importance)
        self.deadline = try container.decodeIfPresent(Int.self, forKey: .deadline)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        self.createdAt = try container.decode(Int.self, forKey: .createdAt)
        self.changedAt = try container.decode(Int.self, forKey: .changedAt)
        self.color = try container.decode(String.self, forKey: .color) ?? "#FFFFFF"
        self.lastUpdatedBy = try container.decode(String.self, forKey: .lastUpdatedBy)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case importance
        case deadline
        case isCompleted = "done"
        case createdAt = "created_at"
        case changedAt = "changed_at"
        case color
        case lastUpdatedBy = "last_updated_by"
    }
    
    enum DecodeErrors: Error {
        case failedMakingImportance
        case failedMakingCreationDate
    }
    
    func decodeToTodoitem() throws -> TodoItem {
        guard let importance = TodoItem.Importance.fromImportanceToNetworkValue(importance: importance) else {
            throw DecodeErrors.failedMakingImportance
        }
        
        let createdAt = Date(timeIntervalSince1970: TimeInterval(createdAt))
        
        let deadline: Date? = deadline != nil ? Date(timeIntervalSince1970: TimeInterval(deadline!)) : nil
        
        let changedAt: Date? = Date(timeIntervalSince1970: TimeInterval(changedAt))
        
        
        return TodoItem(
            id: self.id,
            text: self.text,
            importance: importance,
            deadline: deadline,
            isCompleted: self.isCompleted,
            createdAt: createdAt,
            changedAt: changedAt,
            color: "#FFFFFF",
            category: .other)
    }
}
