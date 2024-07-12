//
//  TodoCalendarController+Extensions.swift
//  ToDoList
//
//  Created by Powers Mikaela on 01.07.2024.
//

import SwiftUI
import UIKit

struct Section {
    let date: String
    let todos: [TodoItemViewModel]
}

// MARK: - Collection extensions

extension TodoCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}

extension TodoCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewWithDates.dequeueReusableCell(withReuseIdentifier: "TodoCalendarCell", for: indexPath) as! TodoCalendarCell
        let lastItemIndex = collectionViewWithDates.numberOfItems(inSection: indexPath.section) - 1

        if indexPath.item == lastItemIndex {
            cell.label.text = "Другое"
        } else {
            let date = dateParser(dates[indexPath.row])
            cell.label.text = "\(date.day)\n\n\(date.month)"
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dict.keys.count
    }

    func dateParser(_ dateString: String) -> (day: Int, month: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)!

        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"
        let month = monthFormatter.string(from: date)

        return (day: day, month: month)
    }
}

extension TodoCalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let targetIndexPath = IndexPath(row: 0, section: indexPath.row)
        tableView.scrollToRow(at: targetIndexPath, at: .top, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let firstVisibleSection = tableView.indexPathsForVisibleRows?.first?.section {
            let indexPath = IndexPath(item: firstVisibleSection, section: 0)
            collectionViewWithDates.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
}

// MARK: - Table extensions

extension TodoCalendarViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].todos.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sections[section].date == "Другое" {
            return sections[section].date
        } else {
            let date = dateParser(sections[section].date)
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
        if tableView.numberOfRows(inSection: indexPath.section) == 1 {
            cell.layer.cornerRadius = 10
        } else {
            let isFirstCell = indexPath.row == 0
            let isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
            if isFirstCell || isLastCell {
                cell.layer.cornerRadius = 10
                cell.clipsToBounds = true
                cell.layer.maskedCorners = isFirstCell ? [.layerMinXMinYCorner, .layerMaxXMinYCorner] : [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        }

        let task = sections[indexPath.section].todos[indexPath.item]
        cell.configure(with: task.todoItem)
        return cell
    }
}

extension TodoCalendarViewController: UITableViewDelegate {
    @objc func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
            self.sections[indexPath.section].todos[indexPath.row].didCompleted()
            completionHandler(true)
        }
        deleteAction.image = UIImage(named: Images.completed)
        deleteAction.backgroundColor = ColorsUIKit.green
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        tableView.reloadData()
        return configuration
    }

    @objc func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Отменить") { _, _, completionHandler in
            self.sections[indexPath.section].todos[indexPath.row].didUnCompleted()
            completionHandler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        tableView.reloadData()
        return configuration
    }

    func strikeThroughLabel(label: UILabel) {
        guard let text = label.text else { return }

        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.strikethroughStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
    }

    func scrollToTableCell(at indexPath: IndexPath, animated: Bool = true) {
        tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
    }
}

extension TodoCalendarViewController {
    @objc func openTodoItemEditView() {
        todoListViewModel.addNew()
        guard let last = todoListViewModel.items.last else {
            return
        }

        let swiftUIHostingController = UIHostingController(rootView: ToDoItemView(todoItemViewModel: last))
        present(swiftUIHostingController, animated: true)
    }
}

extension TodoCalendarViewController: TodoListViewControllerDelegate {
    func didUpdateTodoList() {
        tableView.reloadData()
        collectionViewWithDates.reloadData()
    }
}
