//
//  TodoCalendarController+Extensions.swift
//  ToDoList
//
//  Created by Powers Mikaela on 01.07.2024.
//

import UIKit

extension TodoCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80) // Размер ячейки
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
            if indexPath.row % 2 == 1 {
                let items = dict.sorted { (first, second) -> Bool in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"

                    let firstDate = (first.key == "Другое") ? Date.distantFuture : dateFormatter.date(from: first.key)
                    let secondDate = (second.key == "Другое") ? Date.distantFuture : dateFormatter.date(from: second.key)

                    return firstDate! < secondDate!
                }.map { $0.value }

                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoCell", for: indexPath) as! TodoCell
                cell.label.text = items[indexPath.row][0].todoItem.text
                return cell
            } else {
                let lastItemIndex = collectionView.numberOfItems(inSection: indexPath.section) - 1
                if indexPath.row == lastItemIndex {
                    let dates = dict.keys.sorted()
                    let date = dateParser(dates[indexPath.row])
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
                    cell.label.text = "\(date.day) \(date.month)"
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
                    cell.label.text = "Другое"
                    return cell
                }

            }
            
        }
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return dict.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewWithDates {
            return dict.keys.count
        } else {
            return 2
        }
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
