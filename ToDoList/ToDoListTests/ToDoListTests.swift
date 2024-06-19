//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Powers Mikaela on 6/18/24.
//
@testable import ToDoList
import XCTest

final class ToDoListTests: XCTestCase {
    //testing default initializator
    func testInit() {
        
        let givenId = UUID().uuidString
        let givenText = "Купить продукты"
        let givenImportance = ToDoItem.Importance.usual
        let givenDeadline: Date? = Date().addingTimeInterval(5000)
        let givenIsCompleted = false
        let givenCreationDate = Date()
        let givenModificationDate: Date? = Date().addingTimeInterval(3000)
        
        let toDoItem = ToDoItem(
            id: givenId,
            text: givenText,
            importance: givenImportance,
            deadline: givenDeadline,
            isCompleted: givenIsCompleted,
            creationDate: givenCreationDate,
            modificationDate: givenModificationDate
        )
        
        XCTAssertEqual(toDoItem.id, givenId, "Invalid identifier of item")
        XCTAssertEqual(toDoItem.text, givenText, "Invalid text of item")
        XCTAssertEqual(toDoItem.importance, givenImportance, "Invalid importanse of item")
        XCTAssertEqual(toDoItem.deadline, givenDeadline, "Invalid deadline of item")
        XCTAssertEqual(toDoItem.isCompleted, givenIsCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(toDoItem.creationDate, givenCreationDate, "Invalid creation date")
        XCTAssertEqual(toDoItem.modificationDate, givenModificationDate, "Invalid modification date")
        
    }
    
    //testing JSONparser
    func testParseJSONfromDictionary() {
        
        let givenId = "12345"
        let givenText = "Купить продукты"
        let givenImportance = ToDoItem.Importance.usual
        let givenDeadline: Date? = Date().addingTimeInterval(5000)
        let givenIsCompleted = true
        let givenCreationDate = Date()
        let givenModificationDate: Date? = Date().addingTimeInterval(3000)
        
        let toDoItem = ToDoItem(
            id: givenId,
            text: givenText,
            importance: givenImportance,
            deadline: givenDeadline,
            isCompleted: givenIsCompleted,
            creationDate: givenCreationDate,
            modificationDate: givenModificationDate
        )
        
        let givenJson: [String: Any] = [
            "id": "12345",
            "text": "Купить продукты",
            "importance": "usual",
            "deadline": Date().addingTimeInterval(5000),
            "isCompleted": true,
            "creationDate": Date(),
            "modificationDate": Date().addingTimeInterval(3000)
        ]
        
        let checkingItem = ToDoItem.parse(json: givenJson)!
        
        XCTAssertEqual(toDoItem.id, checkingItem.id, "Invalid identifier of item")
        XCTAssertEqual(toDoItem.text, checkingItem.text, "Invalid text of item")
        XCTAssertEqual(toDoItem.importance, checkingItem.importance, "Invalid importanse of item")
        XCTAssertEqual(Int(toDoItem.deadline!.timeIntervalSince1970), Int(checkingItem.deadline!.timeIntervalSince1970), "Invalid deadline of item")
        XCTAssertEqual(toDoItem.isCompleted, checkingItem.isCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(Int(toDoItem.creationDate.timeIntervalSince1970), Int(checkingItem.creationDate.timeIntervalSince1970), "Invalid creation date")
        XCTAssertEqual(Int(toDoItem.modificationDate!.timeIntervalSince1970), Int(checkingItem.modificationDate!.timeIntervalSince1970), "Invalid modification date")
        
    }
    
    func testParseJSONfromComputedProperty() {
        
        let givenId = UUID().uuidString
        let giventext = "Купить продукты"
        let givenImportance = ToDoItem.Importance.usual
        let givenDeadline: Date? = Date().addingTimeInterval(2000)
        let givenIsCompleted = true
        let givenCreationDate = Date()
        let givenModificationDate: Date? = Date().addingTimeInterval(7200)
        
        let toDoItem = ToDoItem(
            id: givenId,
            text: giventext,
            importance: givenImportance,
            deadline: givenDeadline,
            isCompleted: givenIsCompleted,
            creationDate: givenCreationDate,
            modificationDate: givenModificationDate
        )
        
        let json = toDoItem.json
        let checkingItem = ToDoItem.parse(json: json)
        
        XCTAssertEqual(checkingItem!.id, givenId, "Invalid identifier of item")
        XCTAssertEqual(checkingItem!.text, giventext, "Invalid text of item")
        XCTAssertEqual(checkingItem!.importance, givenImportance, "Invalid importanse of item")
        XCTAssertEqual(Int(checkingItem!.deadline!.timeIntervalSince1970), Int(givenDeadline!.timeIntervalSince1970), "Invalid deadline of item")
        XCTAssertEqual(checkingItem!.isCompleted, givenIsCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(Int(checkingItem!.creationDate.timeIntervalSince1970), Int(givenCreationDate.timeIntervalSince1970), "Invalid creation date")
        XCTAssertEqual(Int(checkingItem!.modificationDate!.timeIntervalSince1970), Int(givenModificationDate!.timeIntervalSince1970), "Invalid modification date")
        
    }
     
    func testParseJSONwithoutId() {

        let givenText = "Купить продукты"
        let givenImportance = ToDoItem.Importance.usual
        let givenDeadline: Date? = Date().addingTimeInterval(5000)
        let givenIsCompleted = false
        let givenCreationDate = Date()
        let givenModificationDate: Date? = Date().addingTimeInterval(3000)
        
        let toDoItem = ToDoItem(
            text: givenText,
            importance: givenImportance,
            deadline: givenDeadline,
            isCompleted: givenIsCompleted,
            creationDate: givenCreationDate,
            modificationDate: givenModificationDate
        )
        
        XCTAssertEqual(toDoItem.text, givenText, "Invalid text of item")
        XCTAssertEqual(toDoItem.importance, givenImportance, "Invalid importanse of item")
        XCTAssertEqual(toDoItem.deadline, givenDeadline, "Invalid deadline of item")
        XCTAssertEqual(toDoItem.isCompleted, givenIsCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(toDoItem.creationDate, givenCreationDate, "Invalid creation date")
        XCTAssertEqual(toDoItem.modificationDate, givenModificationDate, "Invalid modification date")
        
    }

    func testParseJSONwithoutOptionalValues() {
        
        let givenId = UUID().uuidString
        let giventext = "Купить продукты"
        let givenImportance = ToDoItem.Importance.usual
        let givenDeadline: Date? = nil
        let givenIsCompleted = true
        let givenCreationDate = Date()
        let givenModificationDate: Date? = nil
        
        let toDoItem = ToDoItem(
            id: givenId,
            text: giventext,
            importance: givenImportance,
            deadline: givenDeadline,
            isCompleted: givenIsCompleted,
            creationDate: givenCreationDate,
            modificationDate: givenModificationDate
        )
        
        let json = toDoItem.json
        let checkingItem = ToDoItem.parse(json: json)
        
        XCTAssertEqual(checkingItem!.id, givenId, "Invalid identifier of item")
        XCTAssertEqual(checkingItem!.text, giventext, "Invalid text of item")
        XCTAssertEqual(checkingItem!.importance, givenImportance, "Invalid importanse of item")
        XCTAssertNil(checkingItem?.deadline)
        XCTAssertEqual(checkingItem!.isCompleted, givenIsCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(Int(checkingItem!.creationDate.timeIntervalSince1970), Int(givenCreationDate.timeIntervalSince1970), "Invalid creation date")
        XCTAssertNil(checkingItem?.deadline)
        
    }

    func testParseJSONwithoutNonOptionalValues() {
        
        let givenJson: [String: Any] = [
            "id": "12345",
            "text": "Купить продукты",
            "importance": "usual"
        ]
        
        let checkingItem = ToDoItem.parse(json: givenJson)
        
        XCTAssertNil(checkingItem)
        
    }

    func testParseJSONwithInvalidValues() {
        let givenJson: [String: Any] = [
            "id": "12345",
            "text": "Купить продукты",
            "importance": "usual",
            "deadline": "invalid value",
            "isCompleted": "invalid value",
            "creationDate": "invalid value",
            "modificationDate": "invalid value"
        ]
        
        let checkingItem = ToDoItem.parse(json: givenJson)
        
        XCTAssertNil(checkingItem)
        
    }

    func testParseJSONwithoutOneOptionalValue() {
        
        let givenId = "12345"
        let givenText = "Купить продукты"
        let givenImportance = ToDoItem.Importance.usual
        let givenDeadline: Date? = Date().addingTimeInterval(5000)
        let givenIsCompleted = true
        let givenCreationDate = Date()
        let givenModificationDate: Date? = nil
        
        let toDoItem = ToDoItem(
            id: givenId,
            text: givenText,
            importance: givenImportance,
            deadline: givenDeadline,
            isCompleted: givenIsCompleted,
            creationDate: givenCreationDate,
            modificationDate: givenModificationDate
        )
        
        let givenJson: [String: Any] = [
            "id": "12345",
            "text": "Купить продукты",
            "importance": "usual",
            "deadline": Date().addingTimeInterval(5000),
            "isCompleted": true,
            "creationDate": Date(),
        ]
        
        let checkingItem = ToDoItem.parse(json: givenJson)!
        
        XCTAssertEqual(toDoItem.id, checkingItem.id, "Invalid identifier of item")
        XCTAssertEqual(toDoItem.text, checkingItem.text, "Invalid text of item")
        XCTAssertEqual(toDoItem.importance, checkingItem.importance, "Invalid importanse of item")
        XCTAssertEqual(Int(toDoItem.deadline!.timeIntervalSince1970), Int(checkingItem.deadline!.timeIntervalSince1970), "Invalid deadline of item")
        XCTAssertEqual(toDoItem.isCompleted, checkingItem.isCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(Int(toDoItem.creationDate.timeIntervalSince1970), Int(checkingItem.creationDate.timeIntervalSince1970), "Invalid creation date")
        XCTAssertNil(checkingItem.modificationDate)
        
    }

    func testParseJSONwithUsual() {
        
        let givenId = UUID().uuidString
        let giventext = "Купить продукты"
        let givenImportance = ToDoItem.Importance.usual
        let givenDeadline: Date? = Date().addingTimeInterval(2000)
        let givenIsCompleted = true
        let givenCreationDate = Date()
        let givenModificationDate: Date? = Date().addingTimeInterval(7200)
        
        let toDoItem = ToDoItem(
            id: givenId,
            text: giventext,
            importance: givenImportance,
            deadline: givenDeadline,
            isCompleted: givenIsCompleted,
            creationDate: givenCreationDate,
            modificationDate: givenModificationDate
        )
        
        let json = toDoItem.json
        let checkingItem = ToDoItem.parse(json: json)
        
        XCTAssertEqual(checkingItem!.id, givenId, "Invalid identifier of item")
        XCTAssertEqual(checkingItem!.text, giventext, "Invalid text of item")
        XCTAssertEqual(checkingItem!.importance, givenImportance, "Invalid importanse of item")
        XCTAssertEqual(Int(checkingItem!.deadline!.timeIntervalSince1970), Int(givenDeadline!.timeIntervalSince1970), "Invalid deadline of item")
        XCTAssertEqual(checkingItem!.isCompleted, givenIsCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(Int(checkingItem!.creationDate.timeIntervalSince1970), Int(givenCreationDate.timeIntervalSince1970), "Invalid creation date")
        XCTAssertEqual(Int(checkingItem!.modificationDate!.timeIntervalSince1970), Int(givenModificationDate!.timeIntervalSince1970), "Invalid modification date")
        
    }
    
    func testParseJSONwithInvalidImportance() {

        let givenJson: [String: Any] = [
            "id": "12345",
            "text": "Купить продукты",
            "importance": "invalid importance",
            "deadline": Date().addingTimeInterval(5000),
            "isCompleted": true,
            "creationDate": Date(),
            "modificationDate": Date().addingTimeInterval(3000)
        ]
        
        let checkingItem = ToDoItem.parse(json: givenJson)
        
       XCTAssertNil(checkingItem)
        
    }
    
    //testingCSVparser
    func testParseCSVfromString() {
        
        let givenId = "12345"
        let givenText = "Купить продукты"
        let givenImportance = ToDoItem.Importance.usual
        let givenDeadline: Date? = Date().addingTimeInterval(5000)
        let givenIsCompleted = false
        let givenCreationDate = Date()
        let givenModificationDate: Date? = Date().addingTimeInterval(3000)
        
        let givenString = "12345,Купить продукты,false,\(givenCreationDate),usual,\(givenDeadline),\(givenModificationDate)"
        
        let checkingItem = ToDoItem.parse(csv: givenString)!
        
        let toDoItem = ToDoItem(
            id: givenId,
            text: givenText,
            importance: givenImportance,
            deadline: givenDeadline,
            isCompleted: givenIsCompleted,
            creationDate: givenCreationDate,
            modificationDate: givenModificationDate
        )
        
        XCTAssertEqual(toDoItem.id, checkingItem.id, "Invalid identifier of item")
        XCTAssertEqual(toDoItem.text, checkingItem.text, "Invalid text of item")
        XCTAssertEqual(toDoItem.importance, checkingItem.importance, "Invalid importanse of item")
        XCTAssertEqual(Int(toDoItem.deadline!.timeIntervalSince1970), Int(checkingItem.deadline!.timeIntervalSince1970), "Invalid deadline of item")
        XCTAssertEqual(toDoItem.isCompleted, checkingItem.isCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(Int(toDoItem.creationDate.timeIntervalSince1970), Int(checkingItem.creationDate.timeIntervalSince1970), "Invalid creation date")
        XCTAssertEqual(Int(toDoItem.modificationDate!.timeIntervalSince1970), Int(checkingItem.modificationDate!.timeIntervalSince1970), "Invalid modification date")
        
        
    }
    
    func testParseCSVfromComputedProperty() {
        
    }
    func testParseCSVwithoutId() {

    }

    func testParseCSVwithoutOptionalValues() {

    }

    func testParseCSVwithoutNonOptionalValues() {

    }

    func testParseCSVwithInvalidValues() {

    }

    func testParseCSVwithoutOneOptionalValue() {

    }

    func testParseCSVwithUsual() {

    }
    
    func testParseCSVwithInvalidImportance() {
        
    }
}
