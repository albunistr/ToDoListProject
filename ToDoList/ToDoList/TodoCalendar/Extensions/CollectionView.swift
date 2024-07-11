//
//  CollectionView.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 08.07.2024.
//

import UIKit

// MARK: - UICollectionViewDelegateFlowLayout

extension TodoCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}

// MARK: - UICollectionViewDataSource

extension TodoCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewWithDates.dequeueReusableCell(withReuseIdentifier: "TodoCalendarCell",
                                                               for: indexPath) as? TodoCalendarCell ?? TodoCalendarCell()
        let lastItemIndex = collectionViewWithDates.numberOfItems(inSection: indexPath.section) - 1

        if indexPath.item == lastItemIndex {
            cell.label.text = "Другое"
        } else {
            let date = dateParser(todocalendarViewModel.sections[indexPath.row].date)
            cell.label.text = "\(date.day)\n\n\(date.month)"
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todocalendarViewModel.sections.count
    }

    func dateParser(_ dateString: String) -> (day: Int, month: String) {
        guard dateString != "Другое" else {
            return (day: 0, month: "0")
        }
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

// MARK: - UICollectionViewDelegate

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
