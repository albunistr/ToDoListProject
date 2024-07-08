//
//  CalendarWrappers.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 08.07.2024.
//

import SwiftUI
import UIKit

struct UIKitControllerWrapper: UIViewControllerRepresentable {
    var todoListViewModel: TodoListViewModel
    
    func makeUIViewController(context: Context) -> TodoCalendarViewController {
        return TodoCalendarViewController(todoCalendarViewModel: TodoCalendarViewModel(fileCache: todoListViewModel.fileCache))
    }
    
    func updateUIViewController(_ uiViewController: TodoCalendarViewController, context: Context) {
    }
    
}
struct TodoItemViewWrapper: UIViewControllerRepresentable {
    @Binding var isShowed: Bool
    var todoItemViewModel: TodoItemViewModel
    
    func makeUIViewController(context: Context) -> UIHostingController<TodoItemView> {
        return UIHostingController(rootView: TodoItemView(todoItemViewModel: todoItemViewModel, isShowed: $isShowed))
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<TodoItemView>, context: Context) {
        uiViewController.rootView = TodoItemView(todoItemViewModel: todoItemViewModel, isShowed: $isShowed)
    }
}


