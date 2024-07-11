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
