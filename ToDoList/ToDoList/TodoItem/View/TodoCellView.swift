//
//  TodoCellModel.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 25.06.2024.
//

import SwiftUI

struct TodoCellView: View {
    let todoItem: TodoItem
    let completedToggle: () -> Void
    let infoTap: () -> Void
    let deleteTap: () -> Void

    // MARK: - Body

    var body: some View {
        HStack(spacing: 12) {
            completedButton
            Spacer(minLength: 8)
            textOfItem
            Spacer()
            info
        }
        .padding(.vertical, 4)
        .frame(height: 50)
        .swipeActions(edge: .leading) {
            Button {
                completedToggle()
            } label: {
                Images.completed
            }
            .tint(.green)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                deleteTap()
            } label: {
                Images.trash
            }
            .tint(.red)

            Button {
                infoTap()
            } label: {
                Images.info
            }
            .tint(Colors.grayLight)
        }
    }

    // MARK: - Is completed button

    var completedButton: some View {
        VStack {
            if todoItem.isCompleted {
                Images.completed
            } else if todoItem.importance == .important {
                Images.highPriority
            } else {
                Images.propOff
            }
        }
        .onTapGesture {
            completedToggle()
        }
    }

    // MARK: - Deadline text

    var deadline: some View {
        HStack(spacing: 2) {
            if let deadline = todoItem.deadline {
                Images.calendar
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
                Images.iconPickerHighPriority
            }

            if todoItem.importance == .unimportant {
                Images.iconPickerLowPriority
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(todoItem.text)
                    .lineLimit(3)
                    .strikethrough(todoItem.isCompleted)
                    .foregroundColor(todoItem.isCompleted ? 
                                     Colors.labelTertiary :
                                        Colors.labelPrimary)
                deadline
            }

            Spacer()

            Rectangle()
                .fill(Colors.red.colorStringToColor(todoItem.color))
                .frame(width: 5)
        }
    }

    var info: some View {
        Images.modeLight
            .onTapGesture {
                infoTap()
            }
    }
}
