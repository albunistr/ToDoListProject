//
//  CalendarWrappers.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 08.07.2024.
//

import SwiftUI
import UIKit
import CocoaLumberjackSwift

struct TodoItemViewWrapper: UIViewControllerRepresentable {
    @Binding var isShowed: Bool
    var todoItemViewModel: TodoItemViewModel

    func makeUIViewController(context: Context) -> UIHostingController<TodoItemView> {
        DDLogVerbose("Made new TodoItemView from TodoCalendarControlller")
        return UIHostingController(rootView: TodoItemView(todoItemViewModel: todoItemViewModel, isShowed: $isShowed))
    }

    func updateUIViewController(_ uiViewController: UIHostingController<TodoItemView>, context: Context) {
        uiViewController.rootView = TodoItemView(todoItemViewModel: todoItemViewModel, isShowed: $isShowed)
    }
}
