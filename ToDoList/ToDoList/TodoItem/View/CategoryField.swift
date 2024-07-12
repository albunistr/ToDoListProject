//
//  CategoryField.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 08.07.2024.
//

import SwiftUI

struct CategoryFieldView: View {
    @Binding var category: TodoItem.Category

    var body: some View {
        HStack {
            Text(TodoItemViewConstants.category)

            Spacer()

            Picker("", selection: $category) {
                Text(TodoItem.Category.work.rawValue)
                    .tag(TodoItem.Category.work)

                Text(TodoItem.Category.studying.rawValue)
                    .tag(TodoItem.Category.studying)

                Text(TodoItem.Category.hobby.rawValue)
                    .tag(TodoItem.Category.hobby)

                Text(TodoItem.Category.other.rawValue)
                    .tag(TodoItem.Category.other)
            }

            .frame(width: 170, height: 32)
            .background(RoundedRectangle(cornerRadius: 12).fill(Colors.overlay))
        }
    }
}
