//
//  TodoCalendarController+Extensions.swift
//  ToDoList
//
//  Created by Powers Mikaela on 01.07.2024.
//

import UIKit

extension TodoCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
}

extension TodoCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewWithDates {
            let lastItemIndex = collectionView.numberOfItems(inSection: indexPath.section) - 1
            if indexPath.item == lastItemIndex {
                let lactCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoCalendarLastCell", for: indexPath) as! TodoCalendarLastCell
                lactCell.label.text = "Другое"
                return lactCell
            } else {
                let dates = dict.keys.sorted()
                let date = dateParser(dates[indexPath.row])
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoCalendarCell", for: indexPath) as! TodoCalendarCell
                cell.label.text = "\(date.day)\n\n\(date.month)"
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let task = sections[indexPath.section].todos[indexPath.item]
            cell.contentView.backgroundColor = ColorsUIKit.white
            cell.contentView.layer.cornerRadius = 8
            let label = UILabel(frame: cell.contentView.bounds)
            label.text = task.todoItem.text
            label.textAlignment = .left
            label.numberOfLines = 3
            
            let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
            circleView.backgroundColor = UIColor.red
            circleView.layer.cornerRadius = 40
            
            let stackView = UIStackView(arrangedSubviews: [label, circleView])
            stackView.frame = cell.contentView.bounds
            stackView.axis = .horizontal
            stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cell.contentView.addSubview(stackView)
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewWithDates {
            return dict.keys.count
        } else {
            return sections[section].todos.count
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return sections.count
    }


    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        header.backgroundColor = ColorsUIKit.backPrimary
        let label = UILabel(frame: header.bounds)
        
        if sections[indexPath.section].date == "Другое" {
            label.text = "Другое"
        } else {
            let date = dateParser(sections[indexPath.section].date)
            label.text = "\(date.day) \(date.month)"
        }
        
        label.textAlignment = .left
        label.textColor = ColorsUIKit.labelTertiary
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        header.addSubview(label)
        return header
        
    }
    
    private func dateParser(_ dateString: String) -> (day: Int, month: String) {
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

extension TodoCalendarViewController: UICollectionViewDelegate {
}


