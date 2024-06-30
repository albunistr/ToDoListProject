//
//  TodoListViewController.swift
//  ToDoList
//
//  Created by Powers Mikaela on 30.06.2024.
//

import Foundation
import UIKit

class TodoCalendarViewController: UIViewController {
    // MARK: - UI Elements
    
    // MARK: - Class properties
    
    var items: [TodoItemViewModel] = []
    var datesArray = [Date() + 86400, Date() + 192800, Date() + 259200, Date() + 345600]
    var selectedDate: Date?
    var selectedButton: UIButton?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.textAlignment = .center
        mainLabel.textColor = .black
        mainLabel.text = "Мои дела"
        UIFont.boldSystemFont(ofSize: 24)
        view.addSubview(mainLabel)
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .green
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .red
        scrollView.addSubview(contentView)
        

        let buttonTitles =
        [
            "Кнопка 1",
            "Кнопка 2",
            "Кнопка 3",
            "Кнопка 4"
        ]
        
        let date1 = UIButton(type: .system)
        date1.setTitle(buttonTitles[0], for: .normal)
        date1.translatesAutoresizingMaskIntoConstraints = false
        date1.backgroundColor = .blue
        date1.layer.cornerRadius = 16
        contentView.addSubview(date1)

        date1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        date1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        date1.heightAnchor.constraint(equalToConstant: 60).isActive = true
        date1.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        

        
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.topAnchor),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60),
            scrollView.heightAnchor.constraint(equalToConstant: 80),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)])
    }
    
    
}
