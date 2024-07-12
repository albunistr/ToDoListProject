//
//  TodoCalendar+Extension.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 08.07.2024.
//

import UIKit

extension TodoCalendarViewController: TodoListViewControllerDelegate {
    func didUpdateTodoList() {
        tableView.reloadData()
        collectionViewWithDates.reloadData()
    }
}
protocol CellConfigurable {
    func configure(with todoItem: TodoItem)
}
protocol TodoListViewControllerDelegate: AnyObject {
    func didUpdateTodoList()
}
