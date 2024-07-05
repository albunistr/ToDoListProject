//
//  TodoCellModel.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 25.06.2024.
//

import Foundation
import SwiftUI

struct TodoCellView: View {
    @Binding var todoItemViewModel: TodoItemViewModel
    @State var isCompleted: Bool
    
    var todoItem: TodoItem {
        todoItemViewModel.todoItem
    }

    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 12) {
            completedButton
            Spacer(minLength: 8)
            textOfItem
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .onAppear() {
            isCompleted = todoItemViewModel.todoItem.isCompleted
        }
        
    }
    
    // MARK: - Is completed button
    
    var completedButton: some View {
        VStack{
            if isCompleted {
                Image(Images.completed)
            } else if todoItem.importance == .important {
                Image(Images.highPriority)
            } else {
                Image(Images.propOff)
            }
        }
        .onTapGesture {
            isCompleted.toggle()
            todoItemViewModel.didSwitchToggle()
        }
    }
    
    // MARK: - Deadline text
    
    var deadline: some View {
        HStack(spacing: 2){
            if let deadline = todoItem.deadline {
                Image(Images.calendar)
                Text(deadline.formatted(.dateTime.day().month().year()))
                    .foregroundColor(Colors.labelTertiary)
                    .font(.subheadline)
            }
        }
    }
    
    // MARK: - Text of item
    
    var textOfItem: some View {
        HStack(spacing: 2) {
            if todoItem.importance == .important {
                Image(Images.iconPickerHighPriority)
            }
            
            if todoItem.importance == .unimportant {
                Image(Images.iconPickerLowPriority)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(todoItem.text)
                    .lineLimit(3)
                    .strikethrough(isCompleted)
                    .foregroundColor(isCompleted ? Colors.labelTertiary : Colors.labelPrimary)
                deadline
            }
            
            Spacer()
            
            Rectangle()
                .fill(Colors.red.colorStringToColor(todoItemViewModel.todoItem.color))
                .frame(width: 5)
        }
    }
    
    
}


// MARK: PreView

struct TodoCellPreview: PreviewProvider {
    
    @State static var todoItemViewModel = TodoItemViewModel(
        fileCache: FileCache(),
        todoItem: .defaultItem(),
        isNew: false
    )
    
    static var previews: some View {
        TodoCellView(todoItemViewModel: $todoItemViewModel, isCompleted: todoItemViewModel.todoItem.isCompleted)
    }
}


