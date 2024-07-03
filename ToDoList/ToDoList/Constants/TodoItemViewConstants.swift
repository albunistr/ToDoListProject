//
//  TodoItemViewConstants.swift
//  ToDoList
//
//  Created by Powers Mikaela on 6/28/24.
//

import Foundation

enum TodoItemViewConstants {
    static let defaultTextEditor = "Что надо сделать?"
    static let importanceOptions = ["↓", "нет", "‼️"]
    static let categoryOptions = ["работа", "учеба", "хобби", "другое"]
    static let category = "Категория"
    static let importance = "Важность"
    static let doBefore = "Сделать до"
    static let delete = "Удалить"
    static let color = "Цвет"
    static let task = "Дело"
    static let cancel = "Отменить"
    static let save = "Сохранить"
    static let ready = "Готово"
    static let defaultDeadline = Date() + 86400
}
