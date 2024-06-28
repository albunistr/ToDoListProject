@testable import ToDoList
import XCTest

final class ToDoListTests: XCTestCase {
    // testing initializator
    func testInit() {
        let givenId = UUID().uuidString
        let givenText = "Купить продукты"
        let givenImportance = TodoItem.Importance.usual
        let givenDeadline: Date? = Date().addingTimeInterval(5000)
        let givenIsCompleted = false
        let givenCreationDate = Date()
        let givenModificationDate: Date? = Date().addingTimeInterval(3000)
        
        let toDoItem = TodoItem(
            id: givenId,
            text: givenText,
            importance: givenImportance,
            deadline: givenDeadline,
            isCompleted: givenIsCompleted,
            createdAt: givenCreationDate,
            changedAt: givenModificationDate
        )
        
        XCTAssertEqual(toDoItem.id, givenId, "Invalid identifier of item")
        XCTAssertEqual(toDoItem.text, givenText, "Invalid text of item")
        XCTAssertEqual(toDoItem.importance, givenImportance, "Invalid importanse of item")
        XCTAssertEqual(toDoItem.deadline, givenDeadline, "Invalid deadline of item")
        XCTAssertEqual(toDoItem.isCompleted, givenIsCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(toDoItem.createdAt, givenCreationDate, "Invalid creation date")
        XCTAssertEqual(toDoItem.changedAt, givenModificationDate, "Invalid modification date")
    }
    
    // testing JSONparser
    func testParseJSONfromDictionary() {
        let givenId = "12345"
        let givenText = "Купить продукты"
        let givenImportance = TodoItem.Importance.usual
        let givenDeadline: Date? = Date().addingTimeInterval(5000)
        let givenIsCompleted = true
        let givenCreationDate = Date()
        let givenModificationDate: Date? = Date().addingTimeInterval(3000)
        
        let givenJson: [String: Any] = [
            "id": "12345",
            "text": "Купить продукты",
            "importance": "usual",
            "deadline": Date().addingTimeInterval(5000),
            "isCompleted": true,
            "creationDate": Date(),
            "modificationDate": Date().addingTimeInterval(3000)
        ]
        
        let checkingItem = TodoItem.parse(json: givenJson)!
        
        XCTAssertEqual(givenId, checkingItem.id, "Invalid identifier of item")
        XCTAssertEqual(givenText, checkingItem.text, "Invalid text of item")
        XCTAssertEqual(givenImportance, checkingItem.importance, "Invalid importanse of item")
        XCTAssertEqual(Int(givenDeadline!.timeIntervalSince1970), Int(checkingItem.deadline!.timeIntervalSince1970), "Invalid deadline of item")
        XCTAssertEqual(givenIsCompleted, checkingItem.isCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(Int(givenCreationDate.timeIntervalSince1970), Int(checkingItem.createdAt.timeIntervalSince1970), "Invalid creation date")
        XCTAssertEqual(Int(givenModificationDate!.timeIntervalSince1970), Int(checkingItem.changedAt!.timeIntervalSince1970), "Invalid modification date")
    }
    
    func testParseJSONfromComputedProperty() {
        let givenId = UUID().uuidString
        let giventext = "Купить продукты"
        let givenImportance = TodoItem.Importance.usual
        let givenDeadline: Date? = Date().addingTimeInterval(2000)
        let givenIsCompleted = true
        let givenCreationDate = Date()
        let givenModificationDate: Date? = Date().addingTimeInterval(7200)
        
        let toDoItem = TodoItem(
            id: givenId,
            text: giventext,
            importance: givenImportance,
            deadline: givenDeadline,
            isCompleted: givenIsCompleted,
            createdAt: givenCreationDate,
            changedAt: givenModificationDate
        )
        
        let json = toDoItem.json
        let checkingItem = TodoItem.parse(json: json)
        
        XCTAssertEqual(checkingItem!.id, givenId, "Invalid identifier of item")
        XCTAssertEqual(checkingItem!.text, giventext, "Invalid text of item")
        XCTAssertEqual(checkingItem!.importance, givenImportance, "Invalid importanse of item")
        XCTAssertEqual(Int(checkingItem!.deadline!.timeIntervalSince1970), Int(givenDeadline!.timeIntervalSince1970), "Invalid deadline of item")
        XCTAssertEqual(checkingItem!.isCompleted, givenIsCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(Int(checkingItem!.createdAt.timeIntervalSince1970), Int(givenCreationDate.timeIntervalSince1970), "Invalid creation date")
        XCTAssertEqual(Int(checkingItem!.changedAt!.timeIntervalSince1970), Int(givenModificationDate!.timeIntervalSince1970), "Invalid modification date")
    }
     
    func testParseJSONwithoutId() {
        let givenText = "Купить продукты"
        let givenImportance = TodoItem.Importance.usual
        let givenIsCompleted = true
        let givenCreationDate = Date()
        
        let givenJson: [String: Any] = [
            "text": "Купить продукты",
            "importance": "usual",
            "isCompleted": true,
            "creationDate": Date()
        ]
        
        let checkingItem = TodoItem.parse(json: givenJson)!
        
        XCTAssertEqual(givenText, checkingItem.text, "Invalid text of item")
        XCTAssertEqual(givenImportance, checkingItem.importance, "Invalid importanse of item")
        XCTAssertEqual(givenIsCompleted, checkingItem.isCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(Int(givenCreationDate.timeIntervalSince1970), Int(checkingItem.createdAt.timeIntervalSince1970), "Invalid creation date")
    }

    func testParseJSONwithoutOptionalValues() {
        let givenId = UUID().uuidString
        let giventext = "Купить продукты"
        let givenImportance = TodoItem.Importance.usual
        let givenDeadline: Date? = nil
        let givenIsCompleted = true
        let givenCreationDate = Date()
        let givenModificationDate: Date? = nil
        
        let toDoItem = TodoItem(
            id: givenId,
            text: giventext,
            importance: givenImportance,
            deadline: givenDeadline,
            isCompleted: givenIsCompleted,
            createdAt: givenCreationDate,
            changedAt: givenModificationDate
        )
        
        let json = toDoItem.json
        let checkingItem = TodoItem.parse(json: json)
        
        XCTAssertEqual(checkingItem!.id, givenId, "Invalid identifier of item")
        XCTAssertEqual(checkingItem!.text, giventext, "Invalid text of item")
        XCTAssertEqual(checkingItem!.importance, givenImportance, "Invalid importanse of item")
        XCTAssertNil(checkingItem?.deadline)
        XCTAssertEqual(checkingItem!.isCompleted, givenIsCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(Int(checkingItem!.createdAt.timeIntervalSince1970), Int(givenCreationDate.timeIntervalSince1970), "Invalid creation date")
        XCTAssertNil(checkingItem?.deadline)
    }

    func testParseJSONwithoutNonOptionalValues() {
        let givenJson: [String: Any] = [
            "id": "12345",
            "text": "Купить продукты",
            "importance": "usual"
        ]
        
        let checkingItem = TodoItem.parse(json: givenJson)
        
        XCTAssertNil(checkingItem)
    }

    func testParseJSONwithInvalidValues() {
        let givenJson: [String: Any] = [
            "id": "12345",
            "text": "Купить продукты",
            "importance": "usual",
            "deadline": "invalid value",
            "isCompleted": "invalid value",
            "createdAt": "invalid value",
            "modificationDate": "invalid value"
        ]
        
        let checkingItem = TodoItem.parse(json: givenJson)
        
        XCTAssertNil(checkingItem)
    }

    func testParseJSONwithoutOneOptionalValue() {
        let givenId = "12345"
        let givenText = "Купить продукты"
        let givenImportance = TodoItem.Importance.usual
        let givenDeadline: Date? = Date().addingTimeInterval(5000)
        let givenIsCompleted = true
        let givenCreationDate = Date()
 
        let givenJson: [String: Any] = [
            "id": "12345",
            "text": "Купить продукты",
            "importance": "usual",
            "deadline": Date().addingTimeInterval(5000),
            "isCompleted": true,
            "creationDate": Date()
        ]
        
        let checkingItem = TodoItem.parse(json: givenJson)!
        
        XCTAssertEqual(givenId, checkingItem.id, "Invalid identifier of item")
        XCTAssertEqual(givenText, checkingItem.text, "Invalid text of item")
        XCTAssertEqual(givenImportance, checkingItem.importance, "Invalid importanse of item")
        XCTAssertEqual(Int(givenDeadline!.timeIntervalSince1970), Int(checkingItem.deadline!.timeIntervalSince1970), "Invalid deadline of item")
        XCTAssertEqual(givenIsCompleted, checkingItem.isCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(Int(givenCreationDate.timeIntervalSince1970), Int(checkingItem.createdAt.timeIntervalSince1970), "Invalid creation date")
        XCTAssertNil(checkingItem.changedAt)
    }

    func testParseJSONwithUsual() {
        let givenId = UUID().uuidString
        let giventext = "Купить продукты"
        let givenImportance = TodoItem.Importance.usual
        let givenDeadline: Date? = Date().addingTimeInterval(2000)
        let givenIsCompleted = true
        let givenCreationDate = Date()
        let givenModificationDate: Date? = Date().addingTimeInterval(7200)
        
        let toDoItem = TodoItem(
            id: givenId,
            text: giventext,
            importance: givenImportance,
            deadline: givenDeadline,
            isCompleted: givenIsCompleted,
            createdAt: givenCreationDate,
            changedAt: givenModificationDate
        )
        
        let json = toDoItem.json
        let checkingItem = TodoItem.parse(json: json)
        
        XCTAssertEqual(checkingItem!.id, givenId, "Invalid identifier of item")
        XCTAssertEqual(checkingItem!.text, giventext, "Invalid text of item")
        XCTAssertEqual(checkingItem!.importance, givenImportance, "Invalid importanse of item")
        XCTAssertEqual(Int(checkingItem!.deadline!.timeIntervalSince1970), Int(givenDeadline!.timeIntervalSince1970), "Invalid deadline of item")
        XCTAssertEqual(checkingItem!.isCompleted, givenIsCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(Int(checkingItem!.createdAt.timeIntervalSince1970), Int(givenCreationDate.timeIntervalSince1970), "Invalid creation date")
        XCTAssertEqual(Int(checkingItem!.changedAt!.timeIntervalSince1970), Int(givenModificationDate!.timeIntervalSince1970), "Invalid modification date")
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
        
        let checkingItem = TodoItem.parse(json: givenJson)
        
        XCTAssertNil(checkingItem)
    }
    
    // testingCSVparser
    func testParseCSVfromString() {
        let givenId = "12345"
        let givenText = "Купить продукты"
        let givenImportance = TodoItem.Importance.unimportant
        let givenDeadline: Date? = Date(timeIntervalSince1970: TimeInterval(1718877367))
        let givenIsCompleted = false
        let givenCreationDate = Date(timeIntervalSince1970: TimeInterval(1718872367))
        let givenModificationDate: Date? = Date(timeIntervalSince1970: TimeInterval(1718875367))
        
        let givenString = "12345,Купить продукты,false,1718872367,unimportant,1718877367,1718875367"
        let checkingItem = TodoItem.parse(csv: givenString, separator: ",")!
        
        XCTAssertEqual(givenId, checkingItem.id, "Invalid identifier of item")
        XCTAssertEqual(givenText, checkingItem.text, "Invalid text of item")
        XCTAssertEqual(givenImportance, checkingItem.importance, "Invalid importanse of item")
        XCTAssertEqual(Int(givenDeadline!.timeIntervalSince1970), Int(checkingItem.deadline!.timeIntervalSince1970), "Invalid deadline of item")
        XCTAssertEqual(givenIsCompleted, checkingItem.isCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(Int(givenCreationDate.timeIntervalSince1970), Int(checkingItem.createdAt.timeIntervalSince1970), "Invalid creation date")
        XCTAssertEqual(Int(givenModificationDate!.timeIntervalSince1970), Int(checkingItem.changedAt!.timeIntervalSince1970), "Invalid modification date")
    }
    
    func testParseCSVfromComputedProperty() {
        let givenId = "12345"
        let givenText = "Купить продукты"
        let givenImportance = TodoItem.Importance.usual
        let givenDeadline: Date? = Date().addingTimeInterval(5000)
        let givenIsCompleted = false
        let givenCreationDate = Date()
        let givenModificationDate: Date? = Date().addingTimeInterval(3000)
        
        let toDoItem = TodoItem(
            id: givenId,
            text: givenText,
            importance: givenImportance,
            deadline: givenDeadline,
            isCompleted: givenIsCompleted,
            createdAt: givenCreationDate,
            changedAt: givenModificationDate
        )
        
        let csv = toDoItem.csv
        let checkingItem = TodoItem.parse(csv: csv, separator: ",")!
   
        XCTAssertEqual(toDoItem.id, checkingItem.id, "Invalid identifier of item")
        XCTAssertEqual(toDoItem.text, checkingItem.text, "Invalid text of item")
        XCTAssertEqual(toDoItem.importance, checkingItem.importance, "Invalid importanse of item")
        XCTAssertEqual(Int(toDoItem.deadline!.timeIntervalSince1970), Int(checkingItem.deadline!.timeIntervalSince1970), "Invalid deadline of item")
        XCTAssertEqual(toDoItem.isCompleted, checkingItem.isCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(Int(toDoItem.createdAt.timeIntervalSince1970), Int(checkingItem.createdAt.timeIntervalSince1970), "Invalid creation date")
        XCTAssertEqual(Int(toDoItem.changedAt!.timeIntervalSince1970), Int(checkingItem.changedAt!.timeIntervalSince1970), "Invalid modification date")
    }

    func testParseCSVwithoutId() {
        let givenText = "Купить продукты"
        let givenImportance = TodoItem.Importance.unimportant
        let givenDeadline: Date? = Date(timeIntervalSince1970: TimeInterval(1718877367))
        let givenIsCompleted = false
        let givenCreationDate = Date(timeIntervalSince1970: TimeInterval(1718872367))
        let givenModificationDate: Date? = Date(timeIntervalSince1970: TimeInterval(1718875367))
        
        let givenString = ",Купить продукты,false,1718872367,unimportant,1718877367,1718875367"
        
        let checkingItem = TodoItem.parse(csv: givenString, separator: ",")!
        
        XCTAssertEqual(givenText, checkingItem.text, "Invalid text of item")
        XCTAssertEqual(givenImportance, checkingItem.importance, "Invalid importanse of item")
        XCTAssertEqual(Int(givenDeadline!.timeIntervalSince1970), Int(checkingItem.deadline!.timeIntervalSince1970), "Invalid deadline of item")
        XCTAssertEqual(givenIsCompleted, checkingItem.isCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(Int(givenCreationDate.timeIntervalSince1970), Int(checkingItem.createdAt.timeIntervalSince1970), "Invalid creation date")
        XCTAssertEqual(Int(givenModificationDate!.timeIntervalSince1970), Int(checkingItem.changedAt!.timeIntervalSince1970), "Invalid modification date")
    }

    func testParseCSVwithoutOptionalValues() {
        let givenId = "12345"
        let givenText = "Купить продукты"
        let givenImportance = TodoItem.Importance.unimportant
        let givenIsCompleted = false
        let givenCreationDate = Date(timeIntervalSince1970: TimeInterval(1718872367))
        
        let givenString = "12345,Купить продукты,false,1718872367,unimportant,,"
        
        let checkingItem = TodoItem.parse(csv: givenString, separator: ",")!
        
        XCTAssertEqual(givenId, checkingItem.id, "Invalid identifier of item")
        XCTAssertEqual(givenText, checkingItem.text, "Invalid text of item")
        XCTAssertEqual(givenImportance, checkingItem.importance, "Invalid importanse of item")
        XCTAssertNil(checkingItem.deadline)
        XCTAssertEqual(givenIsCompleted, checkingItem.isCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(Int(givenCreationDate.timeIntervalSince1970), Int(checkingItem.createdAt.timeIntervalSince1970), "Invalid creation date")
        XCTAssertNil(checkingItem.changedAt)
    }

    func testParseCSVwithoutNonOptionalValues() {
        let givenString = ",,false,,unimportant,1718877367,1718875367"
        
        let checkingItem = TodoItem.parse(csv: givenString, separator: ",")
        
        XCTAssertNil(checkingItem)
    }

    func testParseCSVwithInvalidValues() {
        let givenString = ",,invalidBool,,unimportant,1718877367,1718875367"
        
        let checkingItem = TodoItem.parse(csv: givenString, separator: ",")
        
        XCTAssertNil(checkingItem)
    }

    func testParseCSVwithUsual() {
        let givenText = "Купить продукты, книгу"
        let givenImportance = TodoItem.Importance.usual
        let givenDeadline: Date? = Date(timeIntervalSince1970: TimeInterval(1718877367))
        let givenIsCompleted = false
        let givenCreationDate = Date(timeIntervalSince1970: TimeInterval(1718872367))
        let givenModificationDate: Date? = Date(timeIntervalSince1970: TimeInterval(1718875367))
        
        let toDoItem = TodoItem(
            text: givenText,
            importance: givenImportance,
            deadline: givenDeadline,
            isCompleted: givenIsCompleted,
            createdAt: givenCreationDate,
            changedAt: givenModificationDate
        )
        
        let givenString = toDoItem.csv
        let checkingItem = TodoItem.parse(csv: givenString, separator: ",")!
        
        XCTAssertEqual(givenText, checkingItem.text, "Invalid text of item")
        XCTAssertEqual(givenImportance, checkingItem.importance, "Invalid importanse of item")
        XCTAssertEqual(Int(givenDeadline!.timeIntervalSince1970), Int(checkingItem.deadline!.timeIntervalSince1970), "Invalid deadline of item")
        XCTAssertEqual(givenIsCompleted, checkingItem.isCompleted, "Invalid isCompleted flag")
        XCTAssertEqual(Int(givenCreationDate.timeIntervalSince1970), Int(checkingItem.createdAt.timeIntervalSince1970), "Invalid creation date")
        XCTAssertEqual(Int(givenModificationDate!.timeIntervalSince1970), Int(checkingItem.changedAt!.timeIntervalSince1970), "Invalid modification date")
    }
    
    func testParseCSVwithInvalidImportance() {
        let givenString = ",Купить продукты,false,1718872367,invalidImportance,1718877367,1718875367"
        
        let checkingItem = TodoItem.parse(csv: givenString, separator: ",")
        
        XCTAssertNil(checkingItem)
    }
}
