import Combine
import Foundation
import CocoaLumberjackSwift

protocol FileCacheProtocol {

    var toDoItems: [TodoItem] { get }

    func addNewOrUpdateItem(_ toDoItem: TodoItem)
    func removeItem(withId id: String)
    func saveItemsToJSON(fileForSaving: String)
    func loadItemsFromJSON(fileForSaving: String)
    func saveToCSV(fileForSaving: String)
    func loadItemsFromCSV(fileForSaving: String)
    
    func loadTodos()
    func addOrUpdateItem(item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteItem(at id: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class FileCache: FileCacheProtocol {
    // MARK: - Class properties
    var revision = 0
    private(set) var networkService: NetworkService = NetworkService(networkClient: NetworkClient())
    private(set) var toDoItems: [TodoItem] = []
    private var isDirty = false {
            didSet {
                print(isDirty)
                if isDirty == true {
                    self.updateAllItems {  _ in }
                }
            }
        }
    
    // MARK: - LifeCycle
    init() {
        self.loadTodos()
    }
    
    // MARK: - Local methods
    func addNewOrUpdateItem(_ toDoItem: TodoItem) {
        if let index = toDoItems.firstIndex(where: { $0.id == toDoItem.id }) {
            toDoItems[index] = toDoItem
        } else {
            toDoItems.append(toDoItem)
        }
    }

    func removeItem(withId id: String) {
        toDoItems.removeAll(where: { $0.id == id })
    }

    func getItems() -> [TodoItem] {
        return toDoItems
    }
    
    // MARK: - Network methods
    func loadTodos() {
        self.getAllItems { result in
            switch result {
            case .success(let data):
                for item in data {
                    self.addNewOrUpdateItem(item)
                }
            case .failure:
                return
            }
        }
    }
    
    func addOrUpdateItem(item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        if self.toDoItems.contains(where: { $0.id == item.id }) {
            DDLogVerbose("Updated item in filecache")
            self.updateItem(item: item) { _ in }
        } else {
            DDLogVerbose("Added item in filecache")
            self.addItem(item: item) { _ in }
        }
    }

    func deleteItem(at id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.removeItem(withId: id)
        networkService.deleteItem(revision: revision, at: id) { [weak self] result in
            switch result {
            case .success(let data):
                self?.revision = data.revision
                completion(.success(()))
            case .failure(let error):
                self?.isDirty = true
                completion(.failure(error))
            }
        }
    }
    
}

private extension FileCache {
    func getAllItems ( completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        networkService.getAllItems(revision: revision) { [weak self] result in
            switch result {
            case .success(let data):
                let revision = data.revision
                
                var list: [TodoItem] = []
                for item in data.list {
                    do {
                        let todoItem = try item.decodeToTodoitem()
                        list.append(todoItem)
                    } catch {
                        completion(.failure(error))
                        return
                    }
                }
                
                self?.toDoItems = list
                self?.revision = revision
                DDLogVerbose("Revision: \(revision)")
                completion(.success(list))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateAllItems(completion: @escaping (Result<Void, Error>) -> Void) {
        networkService.updateAllItems(revision: revision, items: self.toDoItems) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let list = try data.list.map { try $0.decodeToTodoitem() }
                    self?.revision = data.revision
                    for (index, item) in list.enumerated() {
                        self?.addNewOrUpdateItem(item)
                        if index == list.lastIndex(where: { _ in true }) {
                            self?.isDirty = false
                        }
                    }
                } catch {
                    completion(.failure(error))
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addItem(item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        self.addNewOrUpdateItem(item)
        networkService.addItem(revision: revision, item: item) { [weak self] result in
            switch result {
            case .success(let data):
                self?.revision = data.revision
                DDLogVerbose("Success added in filecache, revision: \(data.revision)")
                completion(.success(()))
            case .failure(let error):
                self?.isDirty = true
                DDLogVerbose("Failed adding in filecache")
                completion(.failure(error))
            }
        }
    }
    
    func updateItem(item: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        self.addNewOrUpdateItem(item)
        networkService.updateItem(revision: revision, item) { [weak self] result in
            switch result {
            case .success(let data):
                DDLogVerbose("Success update in filecache, revision: \(data.revision)")
                self?.revision = data.revision
                completion(.success(()))
            case .failure(let error):
                DDLogVerbose("Failed update in filecache")
                self?.isDirty = true
                completion(.failure(error))
            }
        }
    }
}
