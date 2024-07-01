//
//  testingData.swift
//  ToDoList
//
//  Created by Powers Mikaela on 6/27/24.
//

import Combine
import Foundation


var items = [
    TodoItem(text: "Купить сыр", importance: .important, deadline: Date() + 90342),
    TodoItem(text: "Купить голубой сыр с плесенью черного цвета весом 452 грамма в магазине торгового центра на втором этаже около лифта слева", importance: .important),
    TodoItem(text: "Сделать пиццу с колбасой, купленным сыром и помидорами", importance: .usual, deadline: Date() + 896355, isCompleted: true),
    TodoItem(text: "Убрать посуду после готовки, обязательно без использования моющих средств", importance: .unimportant, deadline: Date() + 128456),
    TodoItem(text: "Съесть пиццу", importance: .important, deadline: Date() + 179368, isCompleted: true),
    TodoItem(text: "Купить сыр", importance: .important, deadline: Date() + 90342),
    TodoItem(text: "Купить голубой сыр с плесенью черного цвета весом 452 грамма в магазине торгового центра на втором этаже около лифта слева", importance: .important),
    TodoItem(text: "Сделать пиццу с колбасой, купленным сыром и помидорами", importance: .usual, deadline: Date() + 896355, isCompleted: true),
    TodoItem(text: "Убрать посуду после готовки, обязательно без использования моющих средств", importance: .unimportant, deadline: Date() + 128456),
    TodoItem(text: "Съесть пиццу", importance: .important, deadline: Date() + 754233512, isCompleted: true),
    TodoItem(text: "Купить сыр", importance: .important, deadline: Date() + 565545646),
    TodoItem(text: "Купить голубой сыр с плесенью черного цвета весом 452 грамма в магазине торгового центра на втором этаже около лифта слева", importance: .important),
    TodoItem(text: "Сделать пиццу с колбасой, купленным сыром и помидорами", importance: .usual, deadline: Date() + 896355, isCompleted: true),
    TodoItem(text: "Убрать посуду после готовки, обязательно без использования моющих средств", importance: .unimportant, deadline: Date() + 128456),
    TodoItem(text: "Съесть пиццу", importance: .important, deadline: Date() + 179368, isCompleted: true)
]

var testingFileCache: FileCache = {
    let fileCache = FileCache()
    items.forEach {
        fileCache.addNewOrUpdateItem($0)
    }
    return fileCache
}()
