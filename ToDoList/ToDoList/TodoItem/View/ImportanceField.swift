//
//  ImportanceField.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 08.07.2024.
//

import SwiftUI

struct ImportanceFieldView: View {
    @Binding var importance: TodoItem.Importance

    var body: some View {
        HStack {
            Text(TodoItemViewConstants.importance)

            Spacer()

            Picker("", selection: $importance) {
                Images.iconPickerLowPriority
                    .tag(TodoItem.Importance.unimportant)

                Text("нет").tag(TodoItem.Importance.usual)
                Images.iconPickerHighPriority
                    .tag(TodoItem.Importance.important)
            }

            .frame(width: 170, height: 32)
            .pickerStyle(SegmentedPickerStyle())
            .background(RoundedRectangle(cornerRadius: 12).fill(Colors.overlay))
        }
    }
}
