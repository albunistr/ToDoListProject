//
//  testingData.swift
//  ToDoList
//
//  Created by Powers Mikaela on 6/27/24.
//

import Foundation

var items = [
    TodoItem(text: "Купить сыр", 
             importance: .important,
             deadline: Date() + 90342,
             category: .hobby),
    TodoItem(text: "Купить голубой сыр с плесенью черного цвета",
             importance: .important,
             category: .studying),
    TodoItem(text: "Сделать пиццу с колбасой, купленным сыром и помидорами", 
             importance: .usual,
             deadline: Date() + 896355,
             isCompleted: true,
             category: .work),
    TodoItem(text: "Убрать посуду после готовки, обязательно",
             importance: .unimportant,
             deadline: Date() + 128456,
             category: .studying),
    TodoItem(text: "Съесть пиццу", 
             importance: .important,
             deadline: Date() + 179368, 
             isCompleted: true,
             category: .hobby),
    TodoItem(text: "Купить сыр", 
             importance: .important,
             deadline: Date() + 90342,
             category: .work),
    TodoItem(text: "Купить голубой сыр с плесенью черного цвета",
             importance: .important),
    TodoItem(text: "Сделать пиццу с колбасой, купленным сыром и помидорами", 
             importance: .usual,
             deadline: Date() + 896355,
             isCompleted: true),
    TodoItem(text: "Убрать посуду после готовки, обязательно",
             importance: .unimportant,
             deadline: Date() + 128456),
    TodoItem(text: "Съесть пиццу", 
             importance: .important,
             deadline: Date() + 754233512,
             isCompleted: true),
    TodoItem(text: "Купить сыр", 
             importance: .important,
             deadline: Date() + 565545646),
    TodoItem(text: "Купить голубой сыр с плесенью черного цвета",
             importance: .important),
    TodoItem(text: "Сделать пиццу с колбасой, купленным сыром и помидорами",
             importance: .usual,
             deadline: Date() + 896355,
             isCompleted: true),
    TodoItem(text: "Убрать посуду после готовки, обязательно",
             importance: .unimportant,
             deadline: Date() + 128456),
    TodoItem(text: "Съесть пиццу", 
             importance: .important,
             deadline: Date() + 852369,
             isCompleted: true)
]

var testingFileCache: FileCache = {
    let fileCache = FileCache()
    for item in items {
        fileCache.addNewOrUpdateItem(item)
    }
    return fileCache
}()
