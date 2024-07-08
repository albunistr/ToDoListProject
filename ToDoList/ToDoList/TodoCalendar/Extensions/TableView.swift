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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todocalendarViewModel.sections[section].todos.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if todocalendarViewModel.sections[section].date == "Другое" {
            return todocalendarViewModel.sections[section].date
        } else {
            let date = dateParser(todocalendarViewModel.sections[section].date)
            return "\(date.day) \(date.month)"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "TodoCalendarTableViewCell",
                for: indexPath
            ) as? UITableViewCell & CellConfigurable
        else {
            return UITableViewCell()
        }
        
        let task = todocalendarViewModel.sections[indexPath.section].todos[indexPath.item]
        cell.configure(with: task)
        return cell
    }
}

// MARK: - UITableViewdelegate
extension TodoCalendarViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completedAction = UIContextualAction(style: .normal, title: nil) { (action, view, completionHandler) in
            self.todocalendarViewModel.didCompleted(todoItem: self.todocalendarViewModel.sections[indexPath.section].todos[indexPath.row])
            completionHandler(true)
        }
        completedAction.image = UIImage(named: Images.completed)
        completedAction.backgroundColor = ColorsUIKit.green
        let configuration = UISwipeActionsConfiguration(actions: [completedAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let unCompletedAction = UIContextualAction(style: .normal, title: "Отменить") { (action, view, completionHandler) in
            self.todocalendarViewModel.didUnCompleted(todoItem: self.todocalendarViewModel.sections[indexPath.section].todos[indexPath.row])
            completionHandler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [unCompletedAction])
        return configuration
    }
    
    func scrollToTableCell(at indexPath: IndexPath, animated: Bool = true) {
        tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
    }
}

