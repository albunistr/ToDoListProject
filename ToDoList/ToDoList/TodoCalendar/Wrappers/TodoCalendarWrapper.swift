//
//  File.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 12.07.2024.
//

import SwiftUI
import UIKit
import CocoaLumberjackSwift

struct TodoCalendarWrapper: UIViewControllerRepresentable {
    var todoListViewModel: TodoListViewModel

    func makeUIViewController(context: Context) -> TodoCalendarViewController {
        DDLogVerbose("Made new TodoCalendarViewController")
        return TodoCalendarViewController(todoCalendarViewModel: TodoCalendarViewModel(fileCache: 
                                                                                        todoListViewModel.fileCache))
    }

    func updateUIViewController(_ uiViewController: TodoCalendarViewController, 
                                context: Context) { }
}
