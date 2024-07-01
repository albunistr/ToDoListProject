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
        let lastItemIndex = collectionView.numberOfItems(inSection: indexPath.section) - 1
        
            if indexPath.item == lastItemIndex {
                let lactCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoCalendarLastCell", for: indexPath) as! TodoCalendarLastCell
                lactCell.label.text = "Другое"
                return lactCell
            } else {
                let dates = dict.keys.sorted()
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoCalendarCell", for: indexPath) as! TodoCalendarCell
                cell.label.text = dates[indexPath.row]
                return cell
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dict.keys.sorted().count
    }
}
