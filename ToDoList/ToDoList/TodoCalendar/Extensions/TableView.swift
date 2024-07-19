//
//  TableView.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 08.07.2024.
//

import UIKit

// MARK: - UITableViewDataSource

extension TodoCalendarViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return todocalendarViewModel.sections.count
    }

    func tableView(_ tableView: UITableView, 
                   numberOfRowsInSection section: Int) -> Int {
        return todocalendarViewModel.sections[section].todos.count
    }

    func tableView(_ tableView: UITableView, 
                   titleForHeaderInSection section: Int) -> String? {
        if todocalendarViewModel.sections[section].date == "Другое" {
            return todocalendarViewModel.sections[section].date
        } else {
            let date = dateParser(todocalendarViewModel.sections[section].date)
            return "\(date.day) \(date.month)"
        }
    }

    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "TodoCalendarTableViewCell",
                for: indexPath
            ) as? UITableViewCell & CellConfigurable
        else {
            return UITableViewCell()
        }

        let item = todocalendarViewModel.sections[indexPath.section].todos[indexPath.item]
        cell.configure(with: item)
        return cell
    }
}

// MARK: - UITableViewdelegate

extension TodoCalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = self.todocalendarViewModel.sections[indexPath.section].todos[indexPath.item]
        if !item.isCompleted {
            let completedAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
                self.todocalendarViewModel.completeButtonPressed(indexPath: indexPath)
                self.todocalendarViewModel.didCompleted(todoItem: item)
                completionHandler(true)
            }
            completedAction.image = ImagesUIKit.completed
            completedAction.backgroundColor = ColorsUIKit.green
            let configuration = UISwipeActionsConfiguration(actions: [completedAction])
            return configuration
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = self.todocalendarViewModel.sections[indexPath.section].todos[indexPath.item]
        if item.isCompleted {
            let completedAction = UIContextualAction(style: .normal, title: "Отменить") { _, _, completionHandler in
                self.todocalendarViewModel.didUnCompleted(todoItem: item)
                completionHandler(true)
            }
            completedAction.backgroundColor = ColorsUIKit.grayLight
            let configuration = UISwipeActionsConfiguration(actions: [completedAction])
            return configuration
        } else {
            return nil
        }
    }

    func scrollToTableCell(at indexPath: IndexPath, 
                           animated: Bool = true) {
        self.tableView.scrollToRow(at: indexPath, 
                                   at: .top, 
                                   animated: animated)
    }
}
