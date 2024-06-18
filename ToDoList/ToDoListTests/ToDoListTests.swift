//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Powers Mikaela on 6/18/24.
//
@testable import ToDoList
import XCTest

final class ToDoListTests: XCTestCase {
    func testInit() {
        let id = UUID().uuidString
        let text = "Купить продукты"
        let importance = Importance.Usual
        let deadline: Date? = nil
        let isCompleted = false
        let creationDate = Date()
        let modificationDate: Date? = nil
        
        let toDoItem = ToDoItem(id: id, text: text, importance: importance, deadline: deadline, isCompleted: isCompleted, creationDate: creationDate, modificationDate: modificationDate)
        
        XCTAssertEqual(toDoItem.id, id, "Invalid identifier of item")
        XCTAssertEqual(toDoItem.text, text, "Invalid text of item")
        XCTAssertEqual(toDoItem.importance, importance, "Invalid importanse of item")
        XCTAssertEqual(toDoItem.deadline, deadline, "Invalid deadline of item")
        XCTAssertEqual(toDoItem.isCompleted, isCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(toDoItem.creationDate, creationDate, "Invalid creation date")
        XCTAssertEqual(toDoItem.modificationDate, modificationDate, "Invalid modification date")
    }
    
    func parseJSONS() {
        let id = UUID().uuidString
        let text = "Купить продукты"
        let importance = Importance.Usual
        let deadline: Date? = nil
        let isCompleted = false
        let creationDate = Date()
        let modificationDate: Date? = nil
        
        let toDoItem = ToDoItem(id: id, text: text, importance: importance, deadline: deadline, isCompleted: isCompleted, creationDate: creationDate, modificationDate: modificationDate)
        
        let json = toDoItem.json
        let checkingItem = toDoItem.parse(json: json)
}
