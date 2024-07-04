//
//  TodoCalendarController+Extensions.swift
//  ToDoList
//
//  Created by Powers Mikaela on 01.07.2024.
//

import UIKit

struct Section {
    let date: String
    let todos: [TodoItemViewModel]
}

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
        
        let calendar  = Calendar.current
        let day = calendar.component(.day, from: date)
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"
        let month = monthFormatter.string(from: date)
        
        return (day: day, month: month)
    }
}

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = sections[indexPath.section].todos[indexPath.item]
        cell.contentView.backgroundColor = ColorsUIKit.white

        let label = UILabel()
        if task.todoItem.isCompleted {
            label.attributedText = NSAttributedString(string: task.todoItem.text, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            label.textColor = ColorsUIKit.labelTertiary
        } else {
            label.text = task.todoItem.text
            label.textColor = ColorsUIKit.labelPrimary
        }

        label.textAlignment = .left
        label.numberOfLines = 3

        var imageString = ""
        switch task.todoItem.category {
        case .work:
            imageString = "workColor"
        case .studying:
            imageString = "studyingColor"
        case .hobby:
            imageString = "hobbyColor"
        case .other:
            imageString = "otherColor"
        }
        let circle = UIImage(named: imageString)

        let circleImage = UIImageView(image: circle)
        circleImage.contentMode = .scaleAspectFit
        circleImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        circleImage.heightAnchor.constraint(equalToConstant: 20).isActive = true

        let stackView = UIStackView(arrangedSubviews: [label, circleImage])
        stackView.spacing = 16
        stackView.frame = cell.contentView.bounds
        stackView.axis = .horizontal
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        cell.contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16).isActive = true
        stackView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
        return cell
    }
}

extension TodoCalendarViewController: UICollectionViewDelegate {
}

extension TodoCalendarViewController: UITableViewDelegate {
}

    
