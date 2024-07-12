import Foundation

struct TodoItem: Hashable {
    // MARK: - Properties

    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isCompleted: Bool
    let createdAt: Date
    let changedAt: Date?
    let color: String
    let category: Category

    // MARK: - Init

    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date? = nil,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        changedAt: Date? = nil,
        color: String = "#FFFFFF",
        category: Category = .other
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.changedAt = changedAt
        self.color = color
        self.category = category
    }
}
